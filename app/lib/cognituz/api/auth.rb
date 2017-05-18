require_dependency 'cognituz/api/jwt'

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

    def set_student_defaults(user)
      user.password = SecureRandom.hex(8)
      user.roles = [params[:user_type] || :student]
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

      set_student_defaults(user)

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
        user.roles << :student
        user.save!

        status :ok
        { token: Cognituz::API::JWT.encode_user(user) }
      else
        status :unauthorized
      end
    end

    params { use :login_credentials }
    post '/signup' do
      user = User.new declared(params)

      set_student_defaults(user)

      if user.save!
        status :created
        { token: Cognituz::API::JWT.encode_user(user) }
      else
        status :unprocessable_entity
        error!(user.errors.full_messages.to_sentence, 422)
      end
    end
  end
end
