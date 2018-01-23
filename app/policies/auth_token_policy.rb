class AuthTokenPolicy < ApplicationPolicy
  def create?
    user_valid?
  end
end
