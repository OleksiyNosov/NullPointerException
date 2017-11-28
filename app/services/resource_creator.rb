class ResourceCreator < ResourceCrudWorker
  def initialize resource_class, params
    @resource_class = resource_class
    @params = params
  end

  private
  def process_action
    @resource = @resource_class.new @params

    resource.save
  end
end
