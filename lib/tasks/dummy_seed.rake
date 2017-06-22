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

      20.times { create_user }
    end
  end

  private

  def self.random_boolean
    [true, false].sample
  end

  def self.create_user(attributes = {})
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
      hourly_price:              rand(12..250) * 10,
      taught_subject_ids:        StudySubject.reorder('RANDOM()').first(rand(1..5)).pluck(:id),
      availability_periods_attributes: (1..5).map do |n|
        sunday = Time.new(2017, 03, 26, 0, 0, 0 , -3.hours)

        {
          week_day:  n,
          starts_at: sunday.advance(days: n.days, hours: 8),
          ends_at:   sunday.advance(days: n.days, hours: 16)
        }
      end,
    }.merge(attributes))

    user.save!
  end
end

desc "Seed db with dummy data"
task(dummy_seed: :environment) { DummySeeder.perform }
