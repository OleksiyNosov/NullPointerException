class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  def show
    render json: resource
  end

  def create
    run_resource_creator
      .on :succeeded do |resource|
        render json: resource, status: 201
      end
      .on :failed do |errors|
        render json: errors, status: 422
      end.call
  end

  def update
    run_resource_updator
      .on :succeeded do |resource|
        render json: resource
      end
      .on :failed do |errors|
        render json: errors, status: 422
      end.call
  end

  def destroy
    run_resource_destroyer
      .on :succeeded do
        head 204
      end
      .on :failed do |errors|
        render json: errors, status: 422
      end.call
  end

  private
  def run_resource_updator
    ResourceUpdator.new resource, resource_params
  end

  def run_resource_destroyer
    ResourceDestroyer.new resource
  end
end
