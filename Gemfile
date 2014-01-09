source 'https://rubygems.org'

gem 'rails', '3.2.15'
gem 'mongoid'
gem 'mongoid-history'
gem 'devise'
gem 'mongoid_slug'
gem 'active_model_serializers', github: 'rails-api/active_model_serializers'
gem 'kaminari'
gem 'strong_parameters'
gem 'httparty'

group :development, :test do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "guard-rspec"
end

group :development do
  gem 'wirble'
end

group :test do
  gem "faker", github: 'stympy/faker'
  gem "database_cleaner"
  gem "launchy"
  gem "selenium-webdriver"
  gem "capybara"
end

group :production do
  gem 'rails_12factor'
end

ruby '2.0.0'
