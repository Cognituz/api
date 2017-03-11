class UserSerializer < ApplicationSerializer
  decorate_attachment :avatar

  attributes :id, :avatar, :first_name, :last_name, :age,
    :description, :school_year, :phone_number, :email
end
