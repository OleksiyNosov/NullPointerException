class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  private
  def user_valid?
    user.confirmed?
  end

  def requested_by_author?
    user.id.eql? record.user_id
  end
end
