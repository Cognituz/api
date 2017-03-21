require 'jwt'

module Cognituz::API::JWT
  KEY = Rails.application.secrets.fetch(:secret_key_base)

  def self.encode(payload)
    JWT.encode payload, KEY
  end

  def self.decode(token)
    JWT.decode(token, KEY)
  end

  def self.encode_user(user)
    encode user_id: user.id
  end

  def self.decode_user(token)
    payload = decode(token)[0]
    user_id = payload['user_id']
    user_id && User.find(user_id)
  end
end
