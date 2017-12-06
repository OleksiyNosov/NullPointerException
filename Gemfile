source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{ repo_name }/#{ repo_name }" unless repo_name.include?('/')
  "https://github.com/#{ repo_name }.git"
end

gem 'rails'

gem 'active_model_serializers'
gem 'bcrypt'
gem 'jwt'
gem 'pg'
gem 'puma'
gem 'wisper'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :test do
  gem 'rspec-its'
  gem 'rubocop', require: false
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
