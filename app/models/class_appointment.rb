class ClassAppointment < ApplicationRecord
  attr_accessor :payment_preference
  enum kind: %w[at_teachers_place at_students_place at_public_place online]

  after_commit :schedulle_status_fixing

  after_commit :notify_creation, on: :create
  after_commit :notify_confirmation
  after_commit :notify_cancelation


  state_machine :status, initial: :unconfirmed do
    state :unconfirmed, :confirmed, :live do
      validate :teacher_is_available
      validate :teacher_has_linked_mp_account
      validate :teacher_has_hourly_price
    end

    state :unconfirmed do
      validates_datetime :starts_at, on_or_after: -> { Time.now }
    end

    state :confirmed do
      #validates :mercadopago_payment_id, presence: true
      validates_datetime :starts_at, on_or_after: -> { Time.now }, on: :create
    end

    state :live do
      validates_datetime :starts_at, on_or_before: -> { Time.now }
      validates_datetime :ends_at, on_or_after: -> { Time.now }
    end

    state :expired do
      validates_datetime :ends_at, on_or_before: -> { Time.now }
    end

    state :canceled

    event(:confirm)  { transition unconfirmed: :confirmed }
    event(:set_live) { transition confirmed: :live }
    event(:expire)   { transition all - %i[ex pired canceled] => :expired }
    event(:cancel)   { transition all - %i[canceled] => :canceled }
  end

  with_options class_name: :User do
    belongs_to :teacher, inverse_of: :appointments_as_teacher
    belongs_to :student, inverse_of: :appointments_as_student
  end

  with_options dependent: :destroy do
    has_many :attachments,
      foreign_key: :appointment_id,
      inverse_of: :appointment

    has_many :study_subject_links, class_name: :"StudySubject::Link"
  end

  has_many :study_subjects, through: :study_subject_links

  accepts_nested_attributes_for :attachments

  validates :teacher, :student, :starts_at, :ends_at, :kind, presence: true
  validates :place_desc, presence: true, if: :at_public_place?
  validates_datetime :ends_at, on_or_after: :starts_at

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

  def schedulle_status_fixing
    self.class::StatusFixerJob.tap do |worker|
      worker.set(wait_until: starts_at).perform_later(self)
      worker.set(wait_until: ends_at).perform_later(self)
    end
  end

  def fix_status
    return if new_record?

    if starts_at <= Time.now && ends_at >= Time.now
      confirmed? ? set_live : cancel
    elsif ends_at >= Time.now
      live? ? expire : cancel
    end
  end

  def fix_status!
    fix_status!
    save!
  end

  def notify_creation
    ClassAppointmentsMailer.creation_notification(self).deliver_later
  end

  def notify_confirmation
    return unless previous_changes.key?(:status) && confirmed?
    ClassAppointmentsMailer.confirmation_notification(self).deliver_later
  end

  def notify_cancelation
    return unless previous_changes.key?(:status) && canceled?
    ClassAppointmentsMailer.cancelation_notification(self).deliver_later
  end
end
