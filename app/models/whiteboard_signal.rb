# Allows persistance of a class appointent's whiteboard
# Each record represents a single line or text intersection, or whaterever
# the whiteboard code decides to store via this model.
class WhiteboardSignal < ApplicationRecord
  belongs_to :class_appointment
  validates :function_name, :args, :date, presence: true
  default_scope { order(date: :asc) }
end
