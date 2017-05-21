class MercadoPagoCredential < ApplicationRecord
  belongs_to :user, inverse_of: :mercado_pago_credential
end
