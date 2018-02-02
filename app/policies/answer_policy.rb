class AnswerPolicy < ApplicationPolicy
  def create?
    user_valid?
  end

  def update?
    user_valid? && requested_by_author?
  end

  def destroy?
    user_valid? && requested_by_author?
  end
end
