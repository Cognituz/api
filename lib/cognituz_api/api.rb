class CognituzApi::API < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  helpers do
    def current_user
      authorization_header = request.headers['Authorization']

      token =
        authorization_header
          .try(:match, /\ABearer (.+)\z/)
          .try(:[], 1)

      CognituzApi::JWT.decode_user(token) if token.present?
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

  mount self::Auth
  mount self::Users
  mount self::ContactForms
  mount self::SubjectGroups
end
