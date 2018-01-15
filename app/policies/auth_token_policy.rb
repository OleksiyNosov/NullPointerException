class AuthTokenPolicy < ApplicationPolicy
  def create?
    user.confirmed?
  end
end
