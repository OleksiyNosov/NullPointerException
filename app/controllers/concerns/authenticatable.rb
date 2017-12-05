module Authenticatable
  attr_reader :current_user

  private
  def authenticate_with_token
    token, _options = ActionController::HttpAuthentication::Token.token_and_options(request)

    @current_user = Session.find_by(token: token)&.user

    render status: 401 unless @current_user
  end
end
