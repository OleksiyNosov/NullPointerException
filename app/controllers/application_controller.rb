class ApplicationController < ActionController::API
  include Authenticatable
  include ErrorHandable

  def index
    render json: collection
  end

  def show
    render json: resource
  end
end
