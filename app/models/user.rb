class User < ApplicationRecord
  has_many :question, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_secure_password

  enum status: %i[not_confirmed confirmed]

  validates :first_name, :last_name, presence: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 255 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
end
