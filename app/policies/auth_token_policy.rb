class AuthTokenPolicy < ApplicationPolicy
  def initialize user, params
    @user = user
    @params = params
  end

  def create?
    user_valid?
  end
end
