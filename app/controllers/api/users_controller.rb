class Api::UsersController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    ResourceCreator
      .new(User, resource_params)
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    ResourceUpdator
      .new(resource, resource_params)
      .on(:succeeded) { |resource| render json: resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  private
  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def resource
    @resource ||= User.find params[:id]
  end

  def collection
    User.all
  end
end
