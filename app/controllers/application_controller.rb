class ApplicationController < ActionController::API
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
