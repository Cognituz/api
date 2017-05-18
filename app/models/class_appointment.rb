class ClassAppointment < ApplicationRecord
  attr_reader :duration
  enum kinds: %w[at_teachers_place at_students_place at_public_place online]

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

  validate :teacher_is_available

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

  def duration=(int)
    @duration = int
    set_ends_at
  end

  def starts_at=(date)
    super(date)
    set_ends_at
  end

  private

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
end
