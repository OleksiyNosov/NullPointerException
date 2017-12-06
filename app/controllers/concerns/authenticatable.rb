module Authenticatable
  attr_reader :current_user

  def self.included(base)
    base.before_action :authenticate
  end

  private
  def authenticate

  end
end
