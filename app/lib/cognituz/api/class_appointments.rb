class Cognituz::API::ClassAppointments < Grape::API
  version :v1, using: :path
  before { ensure_authenticated! }

  ENTITY = Cognituz::API::Entities::ClassAppointment

  helpers do
    params :class_appointment_attributes do
      group :class_appointment, type: Hash, default: {} do
        requires :teacher_id, :student_id, :duration, coerce: Integer
        requires :starts_at, coerce: DateTime
        requires :kind, coerce: String
        requires :study_subject_ids, type: Array[Integer]
        optional :desc, type: String

        given kind: -> (k) { k == 'at_public_place' } do
          requires :place_desc, coerce: String
        end

        optional :attachments_attributes, type: Array do
          requires :content
        end

        optional :whiteboard_signals_attributes, type: Array do
          requires :function_name, type: String
          requires :args, type: Array
          requires :date, coerce: DateTime
        end
      end
    end

    params :class_appointment_filters do
      optional :filters, type: Hash, default: {} do
        status_names =
          ClassAppointment
            .state_machine(:status)
            .states.map(&:name).map(&:to_s)

        optional :teacher_id, :student_id, coerce: Integer
        optional :status, type: String, values: status_names
      end
    end
  end

  resources :class_appointments do
    desc "Creates a class appointment between a student and a teacher"
    params { use :class_appointment_attributes }
    post do
      attributes = declared(params).fetch(:class_appointment)
      appointment = ClassAppointment.new(attributes)
      appointment.save!
      appointment.generate_payment_preference!
      present appointment, with: ENTITY
    end

    desc "Retrieves a list of appointments for a teacher or student"
    params { use :class_appointment_filters }
    get do
      filters    = declared(params, include_missing: false).fetch(:filters)
      base_query = ClassAppointment.all
      users      = ClassAppointment::Search.run(base_query, filters).all

      present paginate(users), with: ENTITY
    end

    route_param :id do
      desc "Retrieves a single class appointment"
      get { present ClassAppointment.find(params.fetch(:id)), with: ENTITY }

      desc "Updates an appointment"
      params { use :class_appointment_attributes }
      put do
        attributes = declared(params).fetch(:class_appointment)
        appointment = ClassAppointment.find(params.fetch(:id))
        appointment.update!(attributes)
        present appointment, with: ENTITY
      end

      desc "Triggers a transitional event for for the given class appointment"
      params do
        event_names =
          ClassAppointment
            .state_machine(:status)
            .events.map(&:name).map(&:to_s)

        requires :event, type: String, values: event_names
      end
      put "/transition" do
        appointment = ClassAppointment.find params.fetch(:id)
        transition_name = declared(params).fetch(:event)
        appointment.send(transition_name)
        present appointment, with: ENTITY
      end
    end
  end
end
