require_dependency 'cognituz/api/jwt'

class Cognituz::API::Auth < Grape::API
  version :v1, using: :path

  helpers do
    def get_email(code:, redirect_uri:)
      client = OAuth2::Client.new(
        Rails.application.config.facebook_id,
        Rails.application.config.facebook_secret,
        site:      'https://graph.facebook.com/v2.8',
        token_url: '/oauth/access_token'
      )
      token = client.auth_code.get_token(
        code,
        parser: :facebook,
        redirect_uri: redirect_uri
      )
      resp = token.get('me', params: {fields: 'email'})
      JSON.parse(resp.body).fetch('email')
    end

    def set_user_defaults(user)
      user.password = SecureRandom.hex(8) unless user.encrypted_password.present?
      user_type = declared(params)[:user_type]
      user.roles = user.roles.push(user_type).uniq if user_type.present?
    end

    def set_user_defaults!(user)
      set_user_defaults(user)
      user.save!
    end

    params :signup_params do
      requires :email, :password, type: String
    end

    params :login_credentials do
      use :signup_params
      optional :user_type, type: String
    end
  end

  namespace :auth do
    post '/facebook' do
      email =
        get_email(
          code:         params.fetch(:code),
          redirect_uri: params.fetch(:redirectUri)
        )

      user = User.find_or_initialize_by(email: email)

      set_user_defaults(user)

      if user.save
        { token: Cognituz::API::JWT.encode_user(user) }
      else
        status :unprocessable_entity
        { error: user.errors.full_messages.to_sentence }
      end
    end

    params { use :login_credentials }
    post '/login' do
      user = User.find_by email: declared(params).fetch(:email)
      password = declared(params).fetch(:password)

      if user && user.valid_password?(password)
        set_user_defaults!(user)

        status :ok
        { token: Cognituz::API::JWT.encode_user(user) }
      else
        status :unauthorized
      end
    end

    params { use :signup_params }
    post '/signup' do
      user = User.new(
        email:    declared(params).fetch(:email),
        password: declared(params).fetch(:password),
        roles:    %i[student]
      )
      user.save!
      status :created
      { token: Cognituz::API::JWT.encode_user(user) }
    end
  end
end
