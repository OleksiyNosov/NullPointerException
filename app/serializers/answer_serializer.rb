class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :body
end
