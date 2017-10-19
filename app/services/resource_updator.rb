class ResourceUpdator < ResourceCrudWorker
  def initialize resource, params
    @resource = resource
    @params = params
  end

  def call
    @resource.update @params

    broadcast_resource
  end
end
