# Represents a subject teachable by a teacher.
# These are not supposed to be created by end users for now.
# The seed file creates them.
class StudySubject < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { scope: :level }
end
