require 'jwt'

class JsonWebToken
  class << self
    def encode(payload)
      p payload
      p payload.class
      p Rails.application.credentials.secret_key_base
      JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end

    def decode(token)
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      HashWithIndifferentAccess.new(decoded)
    end
  end
end
