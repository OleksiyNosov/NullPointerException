class Api::QuestionsController < ApplicationController
  before_action -> { use_serializer QuestionSerializer }, only: %i[index show create update]

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
