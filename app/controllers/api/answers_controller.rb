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
    ResourceCreator.new Answer, resource_params
  end
end
