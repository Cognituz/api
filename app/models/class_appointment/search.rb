module ClassAppointment::Search
  extend Cognituz::Search
  filter :status
  filter :teacher_id
  filter :student_id
end
