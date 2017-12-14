class Api::AnswersController < ApplicationController
  skip_before_action :authenticate, only: :index

  def create
    ResourceCreator
      .new(Answer, resource_params)
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    ResourceUpdator
      .new(resource, resource_params)
      .on(:succeeded) { |resource| render json: resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def destroy
    ResourceDestroyer
      .new(resource)
      .on(:succeeded) { head 204 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  private
  def resource_params
    params.require(:answer).permit(:question_id, :body)
  end

  def resource
    @resource ||= Answer.find params[:id]
  end

  def collection
    Answer.all
  end
end
