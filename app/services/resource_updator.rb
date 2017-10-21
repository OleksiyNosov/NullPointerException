class ResourceUpdator < ResourceCrudWorker
  def initialize resource, params
    @resource = resource
    @params = params
  end

  private
  def assemble_resource
    resource.update @params
  end
end
