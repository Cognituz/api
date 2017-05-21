require 'ffaker'
require 'base64'

module DummySeeder
  DEFAULT_AVATAR = File.new(Rails.root.join('vendor/profile_pic.jpg'))

  def self.perform
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
          password:                  'password'
        )
      end
    end
  end

  private

  def self.random_boolean
    [true, false].sample
  end

  def self.create_user(attributes)
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
      long_desc:                 Faker::Lorem.sentences(rand(2..3)).join(' '),
      availability_periods_attributes: (0..6).map do |day|
        {
          starts_at_sfsow: (day * 24 * 60 * 60) + (8 * 60 * 60),
          ends_at_sfsow: (day * 24 * 60 * 60) + (20 * 60 * 60)
        }
      end
    }.merge(attributes))

    user.save!
  end
end

desc "Seed db with dummy data"
task(dummy_seed: :environment) { DummySeeder.perform }