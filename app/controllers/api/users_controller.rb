class Api::UsersController < ApplicationController
  def index
    render json: User.all
  end

  private
  def resource_class
    User
  end
end
