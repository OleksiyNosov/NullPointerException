class ResourceCreator < ResourceCrudWorker
  def initialize params
    @params = params
  end

  def call
    @resource = resource_class.new @params

    broadcast_resource
  end
end
