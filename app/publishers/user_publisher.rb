class UserPublisher
  CHANNEL = 'notifier.email'

  class << self
    def publish attributes
      PubSub.client.publish CHANNEL, attributes.to_json
    end
  end
end
