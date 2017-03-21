class Cognituz::API::Auth < Grape::API
  version :v1, using: :path

  helpers do
    def get_email(code:, redirect_uri:)
      client = OAuth2::Client.new(
        ENV.fetch('FACEBOOK_ID'),
        ENV.fetch('FACEBOOK_SECRET'),
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

    params :login_credentials do
      with type: String do
        requires :email
        requires :password
      end

      optional :roles, type: Array[String]
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
      user.password = SecureRandom.hex(8)
      user.roles = [params[:user_type] || :student]

      if user.save
        render token: Cognituz::API::JWT.encode_user(user)
      else
        status :unprocessable_entity
        render error: user.errors.full_messages.to_sentence
      end
    end

    params { use :login_credentials }
    post '/login' do
      user = User.find_by email: declared(params).fetch(:email)
      password = declared(params).fetch(:password)

      if user && user.valid_password?(password)
        status :ok
        render token: Cognituz::API::JWT.encode_user(user)
      else
        status :unauthorized
      end
    end

    params { use :login_credentials }
    post '/signup' do
      user = User.new declared(params)

      if user.save
        status :created
        render Cognituz::API::JWT.encode_user(user)
      else
        status :unprocessable_entity
        render error: user.errors.full_messages.to_sentence
      end
    end
  end
end
