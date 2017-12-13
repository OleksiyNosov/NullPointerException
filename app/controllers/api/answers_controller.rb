class Api::AnswersController < ApplicationController
  skip_before_action :authenticate, only: :index

  private
  def resource_params
    params.require(:answer).permit(:question_id, :body)
  end
end
