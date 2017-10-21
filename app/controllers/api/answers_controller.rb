class Api::AnswersController < ApplicationController
  def index
    render json: Answer.all
  end

  private
  def resource_class
    Answer
  end

  def resource_params
    params.require(:answer).permit(:question_id, :body)
  end
end
