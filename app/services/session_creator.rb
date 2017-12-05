class SessionCreator < ResourceCrudWorker
  def initialize params
    @email = params[:email]
    @password = params[:password]
  end

  private
  def process_action
    user = User.find_by email: @email

    @resource = Session.new user: user, token: SecureRandom.base64(64)

    @resource.errors.add :password, 'is invalid' unless user&.authenticate @password

    @resource.save
  end
end
