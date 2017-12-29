class JWTWorker
  SECRET_KEY = Rails.application.secrets.secret_key_base

  class << self
    def encode payload
      payload[:exp] ||= 7.days.from_now.to_i

      JWT.encode payload, SECRET_KEY
    end

    def decode token
      JWT.decode token, SECRET_KEY
    rescue JWT::ExpiredSignature, JWT::DecodeError
      false
    end
  end
end
