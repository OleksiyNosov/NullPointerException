class Api::AuthTokensController < ActionController::API
  def create
    if user&.authenticate params[:password]
      render json: { token: new_token }, status: 201
    else
      render json: { errors: 'email or password is invalid' }, status: 422
    end
  end

  private
  def new_token
    JwtWorker.encode user_id: user.id, exp: 7.days.from_now.to_i
  end

  def user
    @user ||= User.find_by email: params[:email]
  end
end
