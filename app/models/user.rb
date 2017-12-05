class User < ApplicationRecord
  include EmailValidations

  has_secure_password

  has_many :sessions

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
