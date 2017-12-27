module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      head 404
    end

    rescue_from ActionController::ParameterMissing do
      head 400
    end
  end
end
