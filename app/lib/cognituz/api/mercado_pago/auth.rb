require 'blanket'

class Cognituz::API::MercadoPago::Auth < Grape::API
  AUTHORIZATION_ENDPOINT =
    "https://auth.mercadopago.com.ar/authorization"

  OAUTH_TOKEN_ENDPOINT =
    "https://api.mercadopago.com/oauth/token"

  helpers do
    def mercado_pago_auth_url
      redirect_uri = File.join(
        Rails.application.config.host,
        v1_mercado_pago_auth_callback_path
      )

      URI(AUTHORIZATION_ENDPOINT).tap do |u|
        u.query = {
          client_id:     Rails.application.config.mercado_pago_id,
          response_type: :code,
          platform_id:   :mp,
          redirect_uri:  callback_url
        }.to_query
      end.to_s
    end

    def callback_url
      on_success_redirect_to = declared(params).fetch(:on_success_redirect_to)

      File.join(
        Rails.application.config.host,
        v1_mercado_pago_auth_callback_path(params: {
          on_success_redirect_to: on_success_redirect_to
        })
      )
    end
  end

  namespace :auth do
    params do
      requires :on_success_redirect_to, type: String,
        desc: "Where to redirect after successfully linking the MP account"
    end
    get(:redirect) { redirect mercado_pago_auth_url }

    params do
      requires :code, :on_success_redirect_to, type: String
    end

    get :callback, as: :v1_mercado_pago_auth_callback do
      code = declared(params).fetch(:code)

      ::Blanket.wrap(OAUTH_TOKEN_ENDPOINT).post(
        headers: {
          "Accept":       "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          client_id:     Rails.application.config.mercado_pago_id,
          client_secret: Rails.application.config.mercado_pago_secret,
          grant_type:    :authorization_code,
          code:          code,
          redirect_uri:  callback_url
        }
      ).tap do |resp|
        (current_user.mercado_pago_credential ||
        current_user.build_mercado_pago_credential)
          .assign_attributes(
            access_token:  resp.access_token,
            refresh_token: resp.payload.refresh_token.presence || resp.try(:refresh_token),
            public_key:    resp.public_key,
          )

        current_user.mercado_pago_user_id = resp.user_id
        current_user.save!
      end

      redirect declared(params).fetch(:on_success_redirect_to)
    end
  end
end
