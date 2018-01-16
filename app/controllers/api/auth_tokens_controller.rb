class Api::AuthTokensController < ActionController::API
  include ErrorHandable
  include Pundit

  def create
    if current_user
      authorize :AuthToken

      if current_user.authenticate resource_params[:password]
        return render json: { token: JWTWorker.encode(user_id: current_user.id) }, status: 201
      end
    end

    render json: { email: ['invalid email'], password: ['invalid password'] }, status: 422
  end

  private
  def resource_params
    params.require(:sign_in).permit(:email, :password)
  end

  def current_user
    @current_user ||= User.find_by(email: resource_params[:email].downcase)
  end
end
