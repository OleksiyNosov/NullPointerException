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

# implements observer logic in controlers
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
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-its'
  gem 'rubocop', require: false
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
