class Cognituz::API::Entities::User < Cognituz::API::Entities::Base
  expose :id, :first_name, :last_name, :age, :description,
    :school_year, :phone_number, :email, :teaches_online,
    :teaches_at_own_place, :teaches_at_public_place,
    :teaches_at_students_place, :is_teacher, :is_student,
    :neighborhoods, :short_desc, :long_desc, :name,
    :linked_mercado_pago_account, :hourly_price, :taught_subject_ids

  expose :avatar, format_with: :attachment

  expose :locations,             using: Cognituz::API::Entities::Location
  expose :taught_subjects,      using: Cognituz::API::Entities::StudySubject
  expose :availability_periods, using: self::AvailabilityPeriod

  private

  def linked_mercado_pago_account() object.mercado_pago_credential.present? end
  def is_teacher() object.roles.try(:include?, 'teacher') end
  def is_student() object.roles.try(:include?, 'student') end

  def hourly_price
    object.hourly_price.to_i
  end
end
