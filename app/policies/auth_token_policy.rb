class AuthTokenPolicy < ApplicationPolicy
  attr_reader :user

  def initialize user
    @user = user
  end

  def create?
    user.email_confirmation
  end
end
