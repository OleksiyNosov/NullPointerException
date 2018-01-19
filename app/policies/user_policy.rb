class UserPolicy < ApplicationPolicy
  def update?
    user.id == record.id
  end

  def confirm?
    user.not_confirmed?
  end
end
