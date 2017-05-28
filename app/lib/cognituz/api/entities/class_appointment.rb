class Cognituz::API::Entities::ClassAppointment < Cognituz::API::Entities::Base
  expose :id, :starts_at, :ends_at, :teacher_id,
    :student_id, :kind, :payment_preference, :duration,
    :desc, :place_desc, :status, :study_subject_ids,
    :available_status_transitions

  expose :student, using: Cognituz::API::Entities::User
  expose :teacher, using: Cognituz::API::Entities::User
  expose :study_subjects, using: Cognituz::API::Entities::StudySubject

  private

  def available_status_transitions
    object.status_transitions.map(&:event)
  end
end
