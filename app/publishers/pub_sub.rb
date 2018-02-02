class PubSub
  class << self
    def client
      Redis.current
    end
  end
end
