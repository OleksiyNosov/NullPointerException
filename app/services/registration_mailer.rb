class RegistrationMailer
  class << self
    def deliver user
      link = "https://lsddev.com/api/registration_confirmations/#{ JWTWorker.encode user_id: user.id }"

      RedisWorker.instance.publish 'notificationer.email', {
        email_attributes: {
          to: user.email,
          from: 'registration@lsddev.com',
          subject: "Your confirmation link: #{ link }"
        },
        event_type: 'registration'
      }.to_json
    end
  end
end
