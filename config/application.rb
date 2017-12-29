require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'

require './app/middleware/catch_json_parse_errors.rb'

Bundler.require(*Rails.groups)

module NullPointerException
  class Application < Rails::Application
    config.load_defaults 5.1

    config.middleware.insert_before Rack::Head, CatchJsonParseErrors

    config.api_only = true
  end
end
