class ResourceCreator
  include Wisper::Publisher

  def initialize params
    @params = params
  end

  def call
    resource = resource_class.new @params

    if resource.save
      broadcast :succeeded, resource
    else
      broadcast :failed, resource.errors
    end
  end
end
