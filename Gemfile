source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.5"

gem "rails", "~> 7.0.6"
gem "sprockets-rails"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'mini_portile2', '2.8.4'
gem 'aws-sdk-s3'
gem 'ransack'
gem 'devise'
gem 'rails-i18n'
gem 'dotenv-rails'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rubocop-airbnb'
  gem "capybara"
  gem "selenium-webdriver"
  gem 'factory_bot_rails'
  gem 'database_cleaner'
end

group :development do
  gem "web-console"
end
