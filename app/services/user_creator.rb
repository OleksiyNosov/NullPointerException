class UserCreator < ResourceCrudWorker
  def initialize params
    @params = params
  end

  def process_action
    @resource = User.new @params

    if @resource.save
      serialized_user_attrs = UserSerializer.new(@resource).attributes

      additianal_attrs = {
        notification: :registration,
        token: JWTWorker.encode(user_id: @resource.id, exp: 1.day.from_now.to_i)
      }

      UserPublisher.publish(serialized_user_attrs.merge(additianal_attrs))
    end
  end
end
