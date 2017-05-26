class Cognituz::API::Entities::ClassAppointment < Cognituz::API::Entities::Base
  expose :id, :starts_at, :ends_at, :teacher_id,
    :student_id, :kind, :payment_preference, :duration,
    :desc, :place_desc, :status

  expose :student, using: Cognituz::API::Entities::User
  expose :teacher, using: Cognituz::API::Entities::User
  expose :available_status_transitions

  private

  def available_status_transitions
    object.status_transitions.map(&:event)
  end
end
