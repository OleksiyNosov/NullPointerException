module Authenticatable
  attr_reader :current_user

  def self.included(base)
    base.before_action :authenticate
  end

  private
  def authenticate
    token, _options = ActionController::HttpAuthentication::Token.token_and_options(request)

    decoded_token = decode_token token

    @current_user = User.find decoded_token[0]['id'] if decoded_token

    render status: 401 unless current_user
  end

  def decode_token token
    JWT.decode token, Session::SECRET_KEY, true, algorithm: Session::ALGORITHM
  rescue JWT::ExpiredSignature, JWT::DecodeError
    false
  end
end
