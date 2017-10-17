class Api::AnswersController < ApplicationController
  def index
    render json: parent.answers
  end

  def show
    render json: resource
  end

  def create
    @answer = Answer.new resource_params.merge(question: parent)

    @answer.save!

    render json: resource
  end

  def update
    resource.update! resource_params

    render json: resource
  end

  def destroy
    resource.destroy!

    head :no_content
  end

  private
  def resource
    @answer ||= parent.answers.find params[:id]
  end

  def resource_params
    params.require(:answer).permit(:body)
  end

  def parent
    @parent ||= Question.find params[:question_id]
  end
end
