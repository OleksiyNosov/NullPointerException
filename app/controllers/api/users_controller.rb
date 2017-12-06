class Api::UsersController < ApplicationController
  skip_before_action :authenticate, only: :create

  private
  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
