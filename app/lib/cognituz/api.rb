class Cognituz::API < Grape::API
  format :json

  helpers do
    def current_user
      return unless auth_token.present?
      Cognituz::API::JWT.decode_user(auth_token)
    end

    def auth_token
      params[:token] ||
      request
        .headers['Authorization']
        .try(:match, /\ABearer (.+)\z/)
        .try(:[], 1)
    end

    def ensure_authenticated!
      return if current_user.present?
      error! "You must be authenticated to perform this action", 401
    end

    def handle_resource_action(resource, &block)
      result = yield(resource)

      if result
        status :ok
        render resource
      else
        status :unprocessable_entity
        render errors: resource.errors.full_messages.to_sentence
      end
    end
  end

  rescue_from(ActiveRecord::RecordInvalid) { |e| error!(e, 422) }

  mount self::Auth
  mount self::Users
  mount self::ContactForms
  mount self::StudySubjects
  mount self::Neighborhoods
  mount self::ClassAppointments
  mount self::MercadoPago
  mount self::WhiteboardSignals
end
