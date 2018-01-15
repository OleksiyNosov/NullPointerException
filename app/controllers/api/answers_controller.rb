class Api::AnswersController < ApplicationController
  skip_before_action :authenticate, only: :index

  before_action -> { authorize resource }, only: %i[update destroy]

  def create
    AnswerCreator.new(question, resource_params)
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    ResourceUpdator.new(resource, resource_params)
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

  private
  def resource_params
    params.require(:answer).permit(:question_id, :user_id, :body)
  end

  def resource
    @resource ||= Answer.find params[:id]
  end

  def collection
    @collection ||= question.answers
  end

  def question
    @question ||= Question.find params[:question_id]
  end
end
