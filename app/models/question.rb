class Question < ApplicationRecord
  has_many :answers

  validates :title, presence: true
end
