class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :body
end
