class User < ApplicationRecord
  has_secure_password

  enum status: %i[not_confirmed confirmed]

  validates :first_name, :last_name, presence: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 255 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

  scope :confirmed?, -> { not not_confirmed? }
end
