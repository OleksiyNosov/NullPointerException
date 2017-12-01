module Authenticatable
  private
  def authenticate_with_token
    token, _options = ActionController::HttpAuthentication::Token.token_and_options(request)

    @current_user = Session.find_by(token: token)&.user

    render status: 401 unless @current_user
  end

  def authenticate_with_password
    user = User.find_by email: params[:email]

    @current_user = user if user&.authenticate params[:password]

    render status: 401 unless @current_user
  end
end
