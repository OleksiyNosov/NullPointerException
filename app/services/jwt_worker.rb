class JwtWorker
  ALGORITHM = 'HS256'
  SECRET_KEY = Rails.application.secrets.secret_key_base

  class << self
    def encode payload
      payload[:exp] ||= 7.days.from_now.to_i

      JWT.encode payload, SECRET_KEY, ALGORITHM
    end

    def decode token
      JWT.decode token, SECRET_KEY, true, algorithm: ALGORITHM
    rescue JWT::ExpiredSignature, JWT::DecodeError
      false
    end
  end
end
