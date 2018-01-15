class UserPublisher
  NOTIFICATION = :registration
  CHANNEL = 'notifier.email'

  class << self
    def publish user
      PubSub.instance.publish CHANNEL, {
        notification: NOTIFICATION,
        email: user.email,
        token: JWTWorker.encode(user_id: user.id, exp: 1.day.from_now.to_i),
        first_name: user.first_name,
        last_name: user.last_name
      }.to_json
    end
  end
end
