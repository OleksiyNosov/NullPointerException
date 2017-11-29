class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication

  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  attr_reader :current_user

  before_action :authenticate

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
  def authenticate
    token, _options = ActionController::HttpAuthentication::Token.token_and_options(request)

    @current_user = Session.find_by(token: token)&.user

    render status: 401 unless @current_user
  end

  def resource
    @resource ||= resource_class.find params[:id]
  end

  def resource_creator
    ResourceCreator.new(resource_class, resource_params)
  end
end
