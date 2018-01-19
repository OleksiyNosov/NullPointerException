class UserCreator < ResourceCrudWorker
  def initialize params
    @params = params
  end

  def process_action
    @params[:email]&.downcase!

    @resource = User.new @params

    if @resource.save
      serialized_user_attrs = UserSerializer.new(@resource).attributes

      additional_attrs = {
        notification: :registration,
        token: JWTWorker.encode(user_id: @resource.id, exp: 1.day.from_now.to_i)
      }

      UserPublisher.publish(serialized_user_attrs.merge(additional_attrs))
    end
  end
end
