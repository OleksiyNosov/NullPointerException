class AnswerPolicy < ApplicationPolicy
  def update?
    requested_by_author?
  end

  def destroy?
    requested_by_author?
  end
end
