class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :tags
end
