class Cognituz::API::Entities::User < Cognituz::API::Entities::Base
  expose :id, :first_name, :last_name, :age, :description,
    :school_year, :phone_number, :email, :teaches_online,
    :teaches_at_own_place, :teaches_at_public_place,
    :teaches_at_students_place, :is_teacher, :is_student
  expose :avatar, format_with: :attachment
  expose :location, using: Cognituz::API::Entities::Location

  private

  def is_teacher() object.roles.include?('teacher') end
  def is_student() object.roles.include?('student') end
end
