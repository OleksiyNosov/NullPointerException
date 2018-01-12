class UserPolicy < ApplicationPolicy
  def update?
    @user.id == @record.id
  end

  def confirm?
    not @user.status.eql? 'confirmed'
  end
end
