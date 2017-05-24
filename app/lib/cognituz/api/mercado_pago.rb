class Cognituz::API::MercadoPago < Grape::API
  version :v1, using: :path
  before { ensure_authenticated! }

  namespace :mercado_pago do
    mount self::Auth
  end
end
