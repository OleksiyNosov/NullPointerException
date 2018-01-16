class Api::AuthTokensController < ActionController::API
  include ErrorHandable
  include Pundit

  def create
    if current_user&.authenticate(resource_params[:password]) && authorize(:AuthToken)
      return render json: { token: JWTWorker.encode(user_id: current_user.id) }, status: 201
    else
      head 403
    end
  end

  private
  def resource_params
    params.require(:sign_in).permit(:email, :password)
  end

  def current_user
    @current_user ||= User.find_by(email: resource_params[:email].downcase)
  end
end
