class Cognituz::API::ClassAppointments < Grape::API
  version :v1, using: :path
  before { ensure_authenticated! }

  resources :class_appointments do
    params do
      group :class_appointment, type: Hash, default: {} do
        requires :teacher_id, :student_id, :duration, coerce: Integer
        requires :starts_at, coerce: DateTime
        requires :kind, coerce: String

        given kind: -> (k) { k == 'at_public_place' } do
          requires :place_desc, coerce: String
        end

        optional :attachments_attributes, type: Array do
          requires :content
        end
      end
    end

    post do
      attributes = declared(params).fetch(:class_appointment)
      appointment = ClassAppointment.new(attributes)
      appointment.save!
      appointment.generate_payment_preference!
      present appointment, with: Cognituz::API::Entities::ClassAppointment
    end
  end
end
