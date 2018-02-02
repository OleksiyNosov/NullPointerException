class Api::QuestionsController < ApplicationController
  skip_before_action :authenticate, only: %i[index show]

  before_action -> { authorize resource }, only: %i[update destroy]

  def create
    authorize(:question, :create?)

    QuestionCreator.new(current_user, resource_params)
      .on(:succeeded) { |serialized_resource| render json: serialized_resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    ResourceUpdator.new(resource, resource_params)
      .on(:succeeded) { |serialized_resource| render json: serialized_resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def destroy
    ResourceDestroyer.new(resource)
      .on(:succeeded) { head 204 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  private
  def resource_params
    params.require(:question).permit(:title, :body)
  end

  def resource
    @resource ||= Question.find params[:id]
  end

  def collection
    @collection ||= Question.all
  end
end
