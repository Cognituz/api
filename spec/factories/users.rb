require 'faker'

FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email do
      name = [first_name, last_name].join('.')
      Faker::Internet.email name
    end
    password { SecureRandom.hex(8) }
  end
end
