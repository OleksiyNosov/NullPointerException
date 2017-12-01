class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  before_action :authenticate_with_password, only: :create

  def index
    render json: current_user.sessions
  end

  private
  def resource_class
    Session
  end

  def resource_creator
    SessionCreator.new user: current_user
  end

  def resource
    @resource ||= current_user.sessions.find params[:id]
  end
end
