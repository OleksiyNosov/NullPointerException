class ApplicationPolicy
  attr_accessor :user, :record

  def initialize(user, record)
    self.user = user
    self.record = record
  end

  def requested_by_author?
    user.id.eql? record.user_id
  end
end
