require 'jwt'

class JsonWebToken
  class << self
    def encode(payload)
      JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end

    def decode(token)
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      HashWithIndifferentAccess.new(decoded)
    end
  end
end
