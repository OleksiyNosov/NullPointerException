module Resourceable
  private
  def resource_class
    @resource_class ||= self.class.controller_name.singularize.camelize.constantize
  end

    def resource
    @resource ||= resource_class.find params[:id]
  end

  def collection
    @collection ||= resource_class.all
  end
end
