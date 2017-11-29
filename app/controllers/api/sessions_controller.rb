class Api::SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def index
    render json: current_user.sessions
  end

  private
  def resource_class
    Session
  end

  def resource_params
    params.require(:session).permit(:email, :password)
  end

  def resource_creator
    SessionCreator.new resource_params
  end

  def resource
    @resource ||= current_user.sessions.find params[:id]
  end
end
