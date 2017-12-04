class Api::AnswersController < ApplicationController
  private
  def resource_params
    params.require(:answer).permit(:question_id, :body)
  end
end
