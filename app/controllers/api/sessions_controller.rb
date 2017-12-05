class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  private
  def resource_creator
    SessionCreator.new resource_params
  end

  def resource
    @resource ||= current_user.sessions.find params[:id]
  end

  def collection
    current_user.sessions
  end

  def resource_params
    params.require(:session).permit(:email, :password)
  end
end
