class Cognituz::API < Grape::API
  format :json

  helpers do
    def current_user
      authorization_header = request.headers['Authorization']

      token =
        authorization_header
          .try(:match, /\ABearer (.+)\z/)
          .try(:[], 1)

      Cognituz::API::JWT.decode_user(token) if token.present?
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
  mount self::SubjectGroups
  mount self::Neighborhoods
end
