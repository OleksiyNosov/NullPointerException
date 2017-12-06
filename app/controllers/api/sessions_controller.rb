class Api::SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  private
  def resource_creator
    SessionCreator.new resource_params
  end

  def resource_params
    params.require(:session).permit(:email, :password)
  end
end
