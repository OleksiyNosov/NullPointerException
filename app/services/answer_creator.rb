class AnswerCreator < ResourceCrudWorker
  def initialize question, params
    @question = question
    @params = params
  end

  private
  def process_action
    @resource = @question.answers.create @params
  end
end
