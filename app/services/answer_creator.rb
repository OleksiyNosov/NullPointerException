class AnswerCreator < ResourceCrudWorker
  def initialize params
    @params = params
  end

  private
  def process_action
    question = Question.find @params[:question_id]

    @resource = question.answers.create @params
  end
end
