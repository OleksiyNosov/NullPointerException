class ResourceDestroyer < ResourceCrudWorker
  def initialize resource
    @resource = resource
  end

  private
  def assemble_resource
    resource.destroy
  end
end
