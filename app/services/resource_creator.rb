class ResourceCreator < ResourceCrudWorker
  def initialize resource_class, params
    @resource_class = resource_class
    @params = params
  end

  private
  def assemble_resource
    @resource = @resource_class.new @params

    resource.save
  end
end
