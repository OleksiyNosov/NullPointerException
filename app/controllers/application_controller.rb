class ApplicationController < ActionController::API
  include Authenticatable

  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  def index
    render json: collection
  end

  def show
    render json: resource
  end
end
