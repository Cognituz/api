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
  end

  mount self::Auth
  mount self::ContactForms
end
