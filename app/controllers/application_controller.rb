class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  def show
    render json: resource
  end

  def create
    run_resource_creator
      .on :succeeded do |resource|
        render json: resource, status: :created
      end
      .on :failed do |errors|
        render json: errors, status: :unprocessable_entity
      end.call
  end
end
