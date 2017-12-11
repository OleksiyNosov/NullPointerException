module Authenticatable
  attr_reader :current_user

  def self.included(base)
    base.before_action :authenticate
  end

  private
  def authenticate
    @current_user = User.find decoded_token&.first['user_id']

    render header: 'WWW-Authenticate', status: 401 unless current_user
  end

  def decoded_token
    @decoded_token ||= JwtWorker.decode token
  end

  def token
    ActionController::HttpAuthentication::Token.token_and_options(request).first
  end
end
