class UserCreator < ResourceCrudWorker
  def initialize params
    @params = params
  end

  def process_action
    @resource = User.new @params

    @resource.save && RegistrationMailPublisher.publish(@resource)
  end
end
