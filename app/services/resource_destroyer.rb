class ResourceDestroyer < ResourceCrudWorker
  def initialize resource
    @resource = resource
  end

  def call
    @resource.destroy

    broadcast_resource
  end
end
