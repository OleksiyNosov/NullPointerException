class ApplicationController < ActionController::API
  include Authenticatable
  include ErrorHandler

  def index
    render json: collection
  end

  def show
    render json: resource
  end
end
