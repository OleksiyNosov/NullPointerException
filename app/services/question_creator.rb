class QuestionCreator < ResourceCrudWorker
  def initialize params
    @params = params
  end

  private
  def process_action
    @resource = Question.create @params
  end
end
