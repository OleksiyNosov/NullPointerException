class ResourceDestroyer < ResourceCrudWorker
  def initialize resource
    @resource = resource
  end

  private
  def process_action
    @resource.destroy
  end
end
