class AuthTokenPolicy < ApplicationPolicy
  def create?
    @user.email_confirmation
  end
end
