class Api::AuthTokensController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def create
    authorize(:auth_token, :create?)

    render json: { token: JWTWorker.encode(user_id: current_user.id) }, status: 201
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic do |email, password|
      @current_user = User.find_by!(email: email.downcase).authenticate(password)
    end
  end
end
