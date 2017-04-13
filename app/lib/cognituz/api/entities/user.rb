class Cognituz::API::Entities::User < Cognituz::API::Entities::Base
  expose :id, :first_name, :last_name, :age, :description,
    :school_year, :phone_number, :email, :teaches_online,
    :teaches_at_own_place, :teaches_at_public_place,
    :teaches_at_students_place, :is_teacher, :is_student,
    :neighborhoods, :short_desc, :long_desc, :name, :subject_groups
  expose :avatar, format_with: :attachment

  expose :location,             using: Cognituz::API::Entities::Location
  expose :taught_subjects,      using: self::TaughtSubject
  expose :availability_periods, using: self::AvailabilityPeriod

  private

  def is_teacher() object.roles.try(:include?, 'teacher') end
  def is_student() object.roles.try(:include?, 'student') end
  def name() [object.first_name, object.last_name].join(' ') end

  def subject_groups
    object.taught_subjects
      .group_by(&:level)
      .map do |level, subjects|
        {
          level: level,
          subjects: subjects.map(&:name)
        }
      end
  end
end
