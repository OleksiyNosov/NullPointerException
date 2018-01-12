class UserPolicy < ApplicationPolicy
  def update?
    @user.id == @record.id
  end

  def confirm?
    not @user.confirmed?
  end
end
