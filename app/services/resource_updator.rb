class ResourceUpdator < ResourceCrudWorker
  def initialize resource, params
    @resource = resource
    @params = params
  end

  private
  def process_action
    @resource.update @params
  end
end
