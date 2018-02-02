class QuestionCreator < ResourceCrudWorker
  def initialize user, params
    @user = user
    @params = params
  end

  private
  def process_action
    @resource = Question.create @params.merge(user: @user)
  end
end
