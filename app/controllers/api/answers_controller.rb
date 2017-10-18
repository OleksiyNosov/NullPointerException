class Api::AnswersController < ApplicationController
  def index
    render json: Answer.all
  end

  def show
    render json: resource
  end

  def create
    @answer = Answer.new resource_params

    resource.save!

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
    @answer ||= Answer.find params[:id]
  end

  def resource_params
    params.require(:answer).permit(:question_id, :body)
  end
end
