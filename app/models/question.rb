class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  validates :tags, length: 1..5
end
