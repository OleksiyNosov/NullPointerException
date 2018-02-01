module Factoriable
  def user_valid_double params = {}
    instance_double(User, id: 0, confirmed?: true, not_confirmed?: false, **params)
  end

  def user_invalid_double params = {}
    instance_double(User, id: 0, confirmed?: false, **params)
  end

  def answer_double params = {}
    instance_double(Answer, id: 0, **params)
  end

  def question_double params = {}
    instance_double(Question, id: 0, **params)
  end
end
