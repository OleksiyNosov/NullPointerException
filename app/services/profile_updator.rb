class ProfileUpdator < ResourceUpdator
  private
  def process_action
    @resource.update @params

    @resource.sessions.destroy_all
  end
end
