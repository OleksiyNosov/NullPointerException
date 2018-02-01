require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'pundit/rspec'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  config.include Authentication

  config.include Dispatchable

  config.include ServiceHandler
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
