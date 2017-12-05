class ApplicationController < ActionController::API
  include Authenticatable
  include Resourceable

  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  def index
    render json: collection
  end

  def show
    render json: resource
  end

  def create
    resource_creator
      .on :succeeded do |resource|
        render json: resource, status: 201
      end
      .on :failed do |errors|
        render json: errors, status: 422
      end.call
  end

  def update
    resource_updator
      .on :succeeded do |resource|
        render json: resource
      end
      .on :failed do |errors|
        render json: errors, status: 422
      end.call
  end

  def destroy
    ResourceDestroyer.new(resource)
      .on :succeeded do
        head 204
      end
      .on :failed do |errors|
        render json: errors, status: 422
      end.call
  end
end
