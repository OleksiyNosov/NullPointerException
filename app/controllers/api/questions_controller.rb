class Api::QuestionsController < ApplicationController
  def index
    render json: Question.all
  end

  def show
    render json: resource
  end

  def create
    @question = Question.new resource_params

    @question.save!

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
    @question ||= Question.find params[:id]
  end

  def resource_params
    params.require(:question).permit(:title, :body)
  end
end
