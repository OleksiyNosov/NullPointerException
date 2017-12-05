module Authenticatable
  attr_reader :current_user

  private
  def authenticate_with_token
    token, _options = ActionController::HttpAuthentication::Token.token_and_options(request)

    @current_user = Session.find_by(token: token)&.user

    render status: 401 unless @current_user
  end

  def authenticate_with_password
    user = User.find_by email: params[:session][:email]

    @current_user = user if user&.authenticate params[:session][:password]

    render json: { errors: { base: ['email or password is invalid'] } }, status: 422 unless @current_user
  end
end
