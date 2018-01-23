class Api::UsersController < ApplicationController
  skip_before_action :authenticate, only: %i[create confirm]

  before_action -> { authorize resource }, only: %i[show update]

  def create
    UserCreator.new(resource_params)
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    UserUpdator.new(resource, resource_params)
      .on(:succeeded) { |resource| render json: resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def confirm
    current_user_from_token(params[:token])

    authorize(:user, :confirm?)

    current_user.confirmed!

    render json: { message: 'user confirmed' }
  end

  private
  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def resource
    @resource ||= User.find params[:id]
  end
end
