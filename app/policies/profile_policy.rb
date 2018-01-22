class ProfilePolicy < ApplicationPolicy
  def show?
    user_valid?
  end
end
