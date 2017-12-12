module Authenticatable
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user

  def self.included(base)
    base.before_action :authenticate
  end

  private
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @decoded_token = JwtWorker.decode token

      @current_user = User.find @decoded_token.first['user_id'] if @decoded_token
    end
  end
end
