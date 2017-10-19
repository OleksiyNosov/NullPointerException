class Api::AnswersController < ApplicationController
  def index
    render json: Answer.all
  end

  private
  def resource
    @answer ||= Answer.find params[:id]
  end

  def resource_params
    params.require(:answer).permit(:question_id, :body)
  end

  def run_resource_creator
    AnswerCreator.new resource_params
  end

  def run_resource_updator
    AnswerUpdator.new resource, resource_params
  end

  def run_resource_destroyer
    AnswerDestroyer.new resource
  end
end
