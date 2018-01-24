class ResourceCrudWorker
  include Homie

  attr_reader :resource

  def initialize
    raise NotImplementedError
  end

  def call
    process_action

    broadcast_resource
  end

  private
  def broadcast_resource
    if resource.valid?
      broadcast :succeeded, serialized_resource
    else
      broadcast :failed, resource.errors
    end
  end

  def serialized_resource
    @serialized_resource ||= ActiveModelSerializers::SerializableResource.new(resource).as_json
  end
end
