class Cognituz::API::Entities::ClassAppointment < Cognituz::API::Entities::Base
  expose :id, :start_time, :end_time, :teacher_id,
    :student_id, :kind, :payment_preference, :duration,
    :desc, :place_desc, :status, :study_subject_ids,
    :available_status_transitions, :attachments_list

  expose :student,            using: Cognituz::API::Entities::User
  expose :teacher,            using: Cognituz::API::Entities::User
  expose :study_subjects,     using: Cognituz::API::Entities::StudySubject
  expose :whiteboard_signals, using: Cognituz::API::Entities::WhiteboardSignal

  private

  def available_status_transitions
    object.status_transitions.map(&:event)
  end

  def attachments_list
    array = []
    object.attachments.each do |attachment|
      array.push(ENV.fetch("HOST") + attachment.content.url)
    end

    return array
  end

  def start_time
    object.starts_at.strftime("%d/%m/%Y - %H:%M")
  end

  def end_time
    object.ends_at.strftime("%d/%m/%Y - %H:%M")
  end
end
