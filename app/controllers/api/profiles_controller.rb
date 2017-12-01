class Api::ProfilesController < ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  private
  def resource_class
    User
  end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def resource
    current_user
  end
end
