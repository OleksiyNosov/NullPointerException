class PubSub
  class << self
    def instance
      @redis ||= Redis.current
    end
  end
end
