class JWTWorker
  SECRET_KEY = Rails.application.secrets.secret_key_base

  class << self
    def encode payload
      payload[:exp] ||= 7.days.from_now.to_i

      JWT.encode payload, SECRET_KEY
    end

    def decode token
      (decoded_token = JWT.decode(token, SECRET_KEY)) && symbolize_keys(decoded_token)
    rescue JWT::ExpiredSignature, JWT::DecodeError
      false
    end

    def symbolize_keys decoded_token
      decoded_token.map { |h| h.transform_keys(&:to_sym) }
    end
  end
end
