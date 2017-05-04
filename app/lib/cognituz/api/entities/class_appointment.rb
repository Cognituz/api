class Cognituz::API::Entities::ClassAppointment < Cognituz::API::Entities::Base
  expose :id, :starts_at, :ends_at, :teacher_id, :student_id, :kind
  expose :student, using: Cognituz::API::Entities::User
  expose :teacher, using: Cognituz::API::Entities::User
end
