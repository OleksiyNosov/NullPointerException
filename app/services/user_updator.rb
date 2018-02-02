class UserUpdator < ResourceUpdator
  private
  def process_action
    @params[:email]&.downcase!

    @resource.update @params
  end
end
