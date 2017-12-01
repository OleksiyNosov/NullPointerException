class ApplicationController < ActionController::API
  include Authenticatable

  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  attr_reader :current_user

  before_action :authenticate_with_token

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

  private
  def resource
    @resource ||= resource_class.find params[:id]
  end

  def resource_creator
    ResourceCreator.new resource_class, resource_params
  end

  def resource_updator
    ResourceUpdator.new resource, resource_params
  end

  def resource_class
    raise NotImplementedError
  end
end
