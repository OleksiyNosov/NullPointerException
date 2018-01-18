class Question < ApplicationRecord
  belongs_to :user

  enum statuses: %i[edited]

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
