class ResourceCreator < ResourceCrudWorker
  def initialize params
    @params = params
  end

  def call
    @resource = resource_class.new @params

    @resource.save

    broadcast_resource
  end
end
