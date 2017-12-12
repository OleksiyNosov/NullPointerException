class Api::QuestionsController < ApplicationController
  skip_before_action :authenticate, only: %i[index show]

  private
  def resource_params
    params.require(:question).permit(:title, :body, tags: [])
  end
end
