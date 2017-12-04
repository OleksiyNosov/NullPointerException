class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_with_token, only: :create

  before_action :authenticate_with_password, only: :create

  private
  def resource_creator
    SessionCreator.new user: current_user
  end

  def resource
    @resource ||= current_user.sessions.find params[:id]
  end

  def collection
    current_user.sessions
  end
end
