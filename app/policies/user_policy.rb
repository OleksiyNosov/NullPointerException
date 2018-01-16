class UserPolicy < ApplicationPolicy
  def update?
    user.id == record.id
  end

  def confirm?
    !user.confirmed?
  end
end
