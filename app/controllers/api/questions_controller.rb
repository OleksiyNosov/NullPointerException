class Api::QuestionsController < ApplicationController
  def index
    render json: Question.all
  end

  private
  def resource
    @question ||= Question.find params[:id]
  end

  def resource_params
    params.require(:question).permit(:title, :body)
  end

  def run_resource_creator
    QuestionCreator.new resource_params
  end
end
