class RedisWorker
  class << self
    def instance
      @redis ||= Redis.new host: 'localhost', port: 6379
    end

    def clear
      @redis = nil
    end
  end
end
