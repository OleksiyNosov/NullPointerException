class AnswerCreator < ResourceCrudWorker
  def initialize question, user, params
    @question = question
    @user = user
    @params = params
  end

  private
  def process_action
    @resource = @question.answers.create @params.merge(user: @user)
  end
end
