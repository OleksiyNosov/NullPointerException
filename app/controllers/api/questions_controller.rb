class Api::QuestionsController < ApplicationController
  def index
    render json: Question.all
  end

  private
  def resource_class
    Question
  end

  def resource_params
    params.require(:question).permit(:title, :body)
  end
end
