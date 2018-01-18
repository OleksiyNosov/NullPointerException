module Authenticatable
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user

  def self.included(base)
    base.before_action :authenticate
  end

  private
  def authenticate
    authenticate_or_request_with_http_token do |token, _|
      current_user_from_token(token, intent: 'authentication')
    end
  end

  def current_user_from_token token, params
    (payload, _ = JWTWorker.decode(token, params)) && (@current_user = User.find payload[:user_id])
  end
end
