class ClassAppointment < ApplicationRecord
  attr_accessor :payment_preference
  enum kind: %w[at_teachers_place at_students_place at_public_place online]

  state_machine :status, initial: :unconfirmed do
    state :confirmed do
      validates :mercadopago_payment_id, presence: true
      validates_time :starts_at, on_or_after: -> { Time.now }
    end

    state :live do
      validates_time :starts_at, on_or_before: -> { Time.now }
      validates_time :ends_at, on_or_after: -> { Time.now }
    end

    state :expired do
      validates_time :ends_at, on_or_before: -> { Time.now }
    end

    state :cancelled

    event(:confirm)     { transition :unconfirmed => :confirmed }
    event(:set_live)    { transition :confirmed => :live }
    event(:set_expired) { transition all - %i[expired cancelled] => :expired }
    event(:cancel)      { transition all - %i[cancelled] => :cancelled }
  end

  with_options class_name: :User do
    belongs_to :teacher, inverse_of: :appointments_as_teacher
    belongs_to :student, inverse_of: :appointments_as_student
  end

  has_many :attachments,
    foreign_key: :appointment_id,
    dependent: :destroy,
    inverse_of: :appointment

  accepts_nested_attributes_for :attachments

  validates :teacher, :student, :starts_at, :ends_at, :kind, presence: true
  validates :place_desc, presence: true, if: :at_public_place?
  validates_time :starts_at, on_or_after: -> { Time.now }
  validates_time :ends_at, on_or_after: :starts_at

  validate :teacher_is_available,          if: :unconfirmed?
  validate :teacher_has_linked_mp_account, if: :unconfirmed?
  validate :teacher_has_hourly_price,      if: :unconfirmed?

  scope :overlapping, -> (start_time:, end_time:, negate: false) do
    query = <<-SQL.strip_heredoc
      #{'NOT' if negate}
      (#{table_name}."starts_at",
      #{table_name}."ends_at") OVERLAPS (?, ?)
    SQL

    where(query, start_time, end_time)
  end

  scope :overlapping_appointment, -> (a) do
    return none unless [a.starts_at, a.ends_at].all?(&:present?)

    where.has do
      (teacher_id == a.teacher_id || a.teacher.try(:id)) |
      (student_id == a.student_id || a.student.try(:id))
    end
    .overlapping(
      start_time: a.starts_at,
      end_time:   a.ends_at
    )
    .where.not id: a.id
  end

  # Represents duration in hours
  def duration
    @duration ||=
      self.starts_at && self.ends_at &&
      ((self.ends_at - self.starts_at) / 60.0 / 60.0)
  end

  # Sets duration. Triggers setting of ends_at
  def duration=(int)
    @duration = int
    set_ends_at
  end

  # Sets starts_at. Triggers setting of ends_at
  def starts_at=(date)
    super(date)
    set_ends_at
  end

  def generate_payment_preference!
    item = {
      title:      "Cognituz: Clase en vivo con profesor #{teacher.name}",
      quantity:   1,
      unit_price: (duration * teacher.hourly_price).to_f
    }

    self.payment_preference =
      Cognituz::MercadoPago::PaymentPreference.new(
        access_token: teacher.mercado_pago_credential.access_token,
        external_ref: "cognituz_class_appointment_#{self.id}",
        items:        [item]
      ).create!
  end

  private

  # Combines duration and starts_at to set ends_at
  def set_ends_at
    return unless self.duration && self.starts_at
    self.ends_at = starts_at + duration.hours
  end

  def teacher_is_available
    return if (
      self.class.overlapping_appointment(self).none? &&
      teacher.availability_periods.containing(starts_at..ends_at).any?
    )
    errors.add :base, :teacher_not_available
  end

  def teacher_has_linked_mp_account
    return if teacher.mercado_pago_credential.try(:access_token)
    errors.add :base, :teacher_has_not_linked_mercado_pago_account
  end

  def teacher_has_hourly_price
    return if teacher.hourly_price.present?
    errors.add :base, :teacher_does_not_have_hourly_price
  end
end
