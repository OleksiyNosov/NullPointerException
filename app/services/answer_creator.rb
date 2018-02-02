class AnswerCreator < ResourceCrudWorker
  def initialize user, params
    @user = user
    @params = params
  end

  private
  def process_action
    question = Question.find @params[:question_id]

    @resource = question.answers.create @params.merge(user: @user)
  end
end
