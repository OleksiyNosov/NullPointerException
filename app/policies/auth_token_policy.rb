class AuthTokenPolicy < ApplicationPolicy
  def create?
    @user.status.eql? 'confirmed'
  end
end
