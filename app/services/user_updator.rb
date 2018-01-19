class UserUpdator < ResourceUpdator
  private
  def process_action
    @resource.update @params

    @resource.email&.downcase!
  end
end


