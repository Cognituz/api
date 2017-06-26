class Cognituz::API::WhiteboardSignals < Grape::API
  version :v1, using: :path
  before { ensure_authenticated! }

  ENTITY = Cognituz::API::Entities::WhiteboardSignal

  resources :whiteboard_signals do
    desc "Creates a whitebaord signal within the given class appointment"
    params do
      group :whiteboard_signal, type: Hash, default: {} do
        requires :data, type: Hash
        requires :date, coerce: DateTime
        requires :class_appointment_id, coerce: Integer
      end
    end
    post do
      attributes = declared(params).fetch(:whiteboard_signal)
      signal = WhiteboardSignal.create!(attributes)
      present signal, with: ENTITY
    end
  end
end
