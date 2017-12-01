class SessionCreator < ResourceCrudWorker
  def initialize params
    @user = params[:user]
  end

  private
  def process_action
    @resource = Session.new user: @user, token: SecureRandom.base64(64)

    @resource.save
  end
end
