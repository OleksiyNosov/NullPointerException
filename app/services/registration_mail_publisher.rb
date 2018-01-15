class RegistrationMailPublisher
  EVENT_TYPE = :registration
  CHANNEL = 'notificationer.email'

  class << self
    def publish user
      PubSub.instance.publish CHANNEL, {
        event_type: EVENT_TYPE,
        email: user.email,
        token: JWTWorker.encode(user_id: user.id, exp: 1.day.from_now.to_i),
        first_name: user.first_name,
        last_name: user.last_name
      }.to_json
    end
  end
end
