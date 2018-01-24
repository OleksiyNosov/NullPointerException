class PubSub
  class << self
    def instance
      Redis.current
    end
  end
end
