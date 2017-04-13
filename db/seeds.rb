# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'ffaker'
require 'base64'

def random_boolean
  [true, false].sample
end

DEFAULT_AVATAR = File.new(Rails.root.join('vendor/profile_pic.jpg'))

def create_user(attributes)
  user = User.new({
    first_name:                first_name = FFaker::Name.first_name,
    last_name:                 last_name = FFaker::Name.last_name,
    email:                     FFaker::Internet.email([first_name, last_name].join(' ')),
    roles:                     ['teacher'],
    teaches_online:            random_boolean,
    teaches_at_own_place:      random_boolean,
    teaches_at_public_place:   random_boolean,
    teaches_at_students_place: random_boolean,
    password:                  'password',
    avatar:                    DEFAULT_AVATAR,
    short_desc:                Faker::Lorem.sentence,
    long_desc:                 Faker::Lorem.sentences(rand(2..3)).join(' ')
  }.merge(attributes))

  user.save!
end

ActiveRecord::Base.transaction do
  User.destroy_all

  create_user(
    email: 'student@gmail.com',
    roles: ['student']
  )

  create_user(
    email: 'teacher@gmail.com',
    roles: ['teacher']
  )

  create_user(
    email: 'both@gmail.com',
    roles: ['teacher', 'student']
  )

  20.times do
    create_user(
      first_name:                first_name = FFaker::Name.first_name,
      last_name:                 last_name = FFaker::Name.last_name,
      email:                     FFaker::Internet.email([first_name, last_name].join(' ')),
      roles:                     ['teacher'],
      teaches_online:            random_boolean,
      teaches_at_own_place:      random_boolean,
      teaches_at_public_place:   random_boolean,
      teaches_at_students_place: random_boolean,
      password:                  'password',

    )
  end
end
