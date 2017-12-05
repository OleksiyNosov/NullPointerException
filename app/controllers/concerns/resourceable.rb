module Resourceable
  private
  def resource_class
    @resource_class ||= resource_class_name.constantize
  end

    def resource
    @resource ||= resource_class.find params[:id]
  end

  def collection
    @collection ||= resource_class.all
  end

  def resource_class_name
    controller_name.singularize.camelize
  end
end
