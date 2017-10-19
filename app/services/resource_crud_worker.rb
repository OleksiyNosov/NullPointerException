class ResourceCrudWorker
  include Wisper::Publisher

  private
  def broadcast_resource
    if @resource.errors.empty?
      broadcast :succceeded, @resource
    else
      broadcast :failed, @resource.errors
    end
  end
end
