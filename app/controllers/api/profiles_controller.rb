class Api::ProfilesController < ApplicationController
  before_action -> { authorize resource }, only: :show

  private
  def resource
    current_user
  end
end
