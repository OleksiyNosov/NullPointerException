class JwtWorker
  ALGORITHM = 'HS256'.freeze
  HEADERS = { typ: 'JWT', alg: ALGORITHM }.freeze
  SECRET_KEY = Rails.application.secrets.secret_key_base

  private_constant :ALGORITHM, :HEADERS, :SECRET_KEY

  class << self
    def encode payload
      JWT.encode payload, SECRET_KEY, ALGORITHM, HEADERS
    end

    def decode token
      JWT.decode token, SECRET_KEY, true, algorithm: ALGORITHM
    rescue JWT::ExpiredSignature, JWT::DecodeError
      false
    end
  end
end
