class UserPolicy < ApplicationPolicy
  def show?
    user_valid?
  end

  def update?
    user_valid? && user.id.eql?(record.id)
  end

  def confirm?
    user.not_confirmed?
  end
end
