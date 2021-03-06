class Api::AuthTokensController < ActionController::API
  include ErrorHandable

  def create
    user = User.find_by email: resource_params[:email]

    if user&.authenticate resource_params[:password]
      render json: { token: JWTWorker.encode(user_id: user.id) }, status: 201
    else
      render json: { email: ['invalid email'], password: ['invalid password'] }, status: 422
    end
  end

  private
  def resource_params
    params.require(:sign_in).permit(:email, :password)
  end
end
