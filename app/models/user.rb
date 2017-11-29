class User < ApplicationRecord
  has_secure_password

  has_many :sessions

  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
end
