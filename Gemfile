source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{ repo_name }/#{ repo_name }" unless repo_name.include?('/')
  "https://github.com/#{ repo_name }.git"
end

gem 'rails'

# serialize models
gem 'active_model_serializers'

# encrypts password
gem 'bcrypt'

# implements observer logic in controllers
gem 'homie'

# creates tokens for authentication
gem 'jwt'

# orm for postgresql
gem 'pg'

# web server
gem 'puma'

# authorize users
gem 'pundit'

# publishes data
gem 'redis'

group :development, :test do
  # generates sample data
  gem 'factory_bot_rails'

  # provides dumb data
  gem 'faker'

  # debugger
  gem 'pry-byebug'
  gem 'pry-rails'

  # testing framework
  gem 'rspec-rails'
end

group :test do
  # cleans database for tests
  gem 'database_cleaner'

  # provides the its method for tests as a short-hand
  gem 'rspec-its'

  # linter
  gem 'rubocop', require: false

  # provides one-liners that test common Rails functionality
  gem 'shoulda-matchers'

  # code coverage analyst
  gem 'simplecov', require: false
end

# compatibility with windows platforms
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
