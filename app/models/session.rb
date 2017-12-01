class Session < ApplicationRecord
  belongs_to :user

  attr_accessor :password

  validate :authenticate_with_token

  private
  def authenticate_with_token
    errors.add :password, 'is invalid' unless user&.authenticate password
  end
end
