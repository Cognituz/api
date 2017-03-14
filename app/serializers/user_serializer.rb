class UserSerializer < ApplicationSerializer
  decorate_attachment :avatar

  attributes :id, :avatar, :first_name, :last_name, :age,
    :description, :school_year, :phone_number, :email,
    :teaches_online, :teaches_at_own_place,
    :teaches_at_public_place, :teaches_at_students_place

  attribute(:is_teacher) { object.roles.include?('teacher') }
  attribute(:is_student) { object.roles.include?('student') }
end
