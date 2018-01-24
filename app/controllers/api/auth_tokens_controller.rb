class Api::AuthTokensController < ActionController::API
  include ErrorHandable
  include Pundit

  def create
    authenticate_with_password

    authorize(:auth_token, :create?)

    render json: { token: JWTWorker.encode(user_id: current_user.id) }, status: 201
  end

  private
  def resource_params
    params.require(:sign_in).permit(:email, :password)
  end

  def current_user
    @current_user ||= User.find_by(email: resource_params[:email].downcase)
  end

  def authenticate_with_password
    current_user&.authenticate(resource_params[:password]) || (raise Pundit::NotAuthorizedError)
  end
end
