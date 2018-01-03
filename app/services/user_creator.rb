class UserCreator < ResourceCreator
  def initialize params
    @params = params
  end

  def process_action
    @resource = User.new @params

    @resource.confirmation_token = SecureRandom.urlsafe_base64(64).to_s

    # TODO: send user data to Slava's redis micro service

    @resource.save
  end
end
