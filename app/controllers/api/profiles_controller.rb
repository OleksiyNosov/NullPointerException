class Api::ProfilesController < ApplicationController
  private
  def resource
    current_user
  end
end
