class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  def show
    render json: resource, serializer: @serializer
  end

  def create
    run_resource_creator
      .on :succeeded do |resource|
        render json: resource, serializer: @serializer, status: :created
      end
      .on :failed do |errors|
        render json: errors, status: :unprocessable_entity
      end.call
  end

  def update
    run_resource_updator
      .on :succeeded do |resource|
        render json: resource, serializer: @serializer
      end
      .on :failed do |errors|
        render json: errors, status: :unprocessable_entity
      end.call
  end

  def destroy
    run_resource_destroyer
      .on :succeeded do
        head :no_content
      end
      .on :failed do |errors|
        render json: errors, status: :unprocessable_entity
      end.call
  end

  private
  def use_serializer serializer
    @serializer = serializer
  end

  def run_resource_updator
    ResourceUpdator.new resource, resource_params
  end

  def run_resource_destroyer
    ResourceDestroyer.new resource
  end
end
