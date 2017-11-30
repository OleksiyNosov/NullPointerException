class Session < ApplicationRecord
  belongs_to :user

  attr_accessor :password

  validate :authenticate

  private
  def authenticate
    errors.add :password, 'is invalid' unless user&.authenticate password
  end
end
