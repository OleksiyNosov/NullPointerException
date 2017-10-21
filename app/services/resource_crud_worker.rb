class ResourceCrudWorker
  include Wisper::Publisher

  attr_reader :resource

  def initialize
    raise NotImplementedError
  end

  def call
    assemble_resource

    broadcast_resource
  end

  private
  def broadcast_resource
    if resource.valid?
      broadcast :succeeded, resource
    else
      broadcast :failed, resource.errors
    end
  end
end
