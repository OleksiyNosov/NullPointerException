class Api::UsersController < ApplicationController
  skip_before_action :authenticate, only: %i[create confirmation]

  def create
    UserCreator.new(resource_params)
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    authorize resource

    ResourceUpdator.new(resource, resource_params)
      .on(:succeeded) { |resource| render json: resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def confirmation
    if (decoded_token = JWTWorker.decode params[:token]) && (user = User.find decoded_token.first['user_id'])
      user.update status: :confirmed

      head 204
    else
      head 404
    end
  end

  private
  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def resource
    @resource ||= User.find params[:id]
  end
end
