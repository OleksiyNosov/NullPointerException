class ApplicationPolicy
  attr_accessor :user, :record

  def initialize(user, record)
    self.user = user
    self.record = record
  end
end
