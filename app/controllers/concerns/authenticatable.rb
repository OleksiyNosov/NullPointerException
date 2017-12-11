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

      if @decoded_token && user_from_token_data
        @current_user = user_from_token_data
      else
        false
      end
    end
  end

  def user_from_token_data
    @user_from_token_data ||= User.find @decoded_token.first['user_id']
  end
end
