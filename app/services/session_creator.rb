class SessionCreator < ResourceCrudWorker
  def initialize params
    @email = params[:email]
    @password = params[:password]
  end

  private
  def process_action
    @resource = Session.new email: @email, password: @password
  end
end
