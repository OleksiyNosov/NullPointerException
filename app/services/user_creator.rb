class UserCreator < ResourceCrudWorker
  def initialize params
    @params = params
  end

  def process_action
    @resource = User.new @params

    if @resource.save
      UserPublisher.publish(
        UserSerializer.new(@resource)
          .attributes
          .merge(
            notification: :registration,
            token: JWTWorker.encode(user_id: @resource.id, exp: 1.day.from_now.to_i)))
    end
  end
end
