class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  def show
    render json: resource
  end

  def create
    ResourceCreator.new(resource_class, resource_params)
      .on :succeeded do |resource|
        render json: resource, status: 201
      end
      .on :failed do |errors|
        render json: errors, status: 422
      end.call
  end

  def update
    ResourceUpdator.new(resource, resource_params)
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

  private
  def resource
    @resource ||= resource_class.find params[:id]
  end
end
