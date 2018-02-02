class Api::UsersController < ApplicationController
  skip_before_action :authenticate, only: %i[create confirm]
  before_action :authenticate_to_confirm, only: :confirm

  before_action -> { authorize resource }, only: %i[show update]

  def create
    UserCreator.new(resource_params)
      .on(:succeeded) { |serialized_resource| render json: serialized_resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    UserUpdator.new(resource, resource_params)
      .on(:succeeded) { |serialized_resource| render json: serialized_resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def confirm
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

  def authenticate_to_confirm
    unless current_user_from_token(params[:token])
      headers['WWW-Authenticate'] = 'Token realm="Application"'

      head 401
    end
  end
end
