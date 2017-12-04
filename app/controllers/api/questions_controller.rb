class Api::QuestionsController < ApplicationController
  private
  def resource_params
    params.require(:question).permit(:title, :body, tags: [])
  end
end
