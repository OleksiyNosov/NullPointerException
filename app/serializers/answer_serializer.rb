class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :user_id, :body
end
