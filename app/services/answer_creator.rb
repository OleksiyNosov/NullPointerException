class AnswerCreator < ResourceCrudWorker
  def initialize question, user, params
    @user = user
    @question = question
    @params = params
  end

  private
  def process_action
    @resource = @question.answers.create @params.merge(user_id: @user.id)
  end
end
