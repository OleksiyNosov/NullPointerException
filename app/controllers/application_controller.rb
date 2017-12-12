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
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    resource_updator
      .on(:succeeded) { |resource| render json: resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def destroy
    ResourceDestroyer.new(resource)
      .on(:succeeded) { head 204 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end
end
