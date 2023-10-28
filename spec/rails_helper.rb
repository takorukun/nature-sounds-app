require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'webmock/rspec'

WebMock.disable_net_connect!(
  allow_localhost: true, 
  allow: [
    "172.21.0.4:3002",
    "chrome:4444"
  ]
)

Capybara.register_driver :selenium_chrome_in_container do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('no-sandbox')
  options.add_argument('disable-dev-shm-usage')
  options.add_argument('remote-debugging-port=9222')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://chrome:4444/wd/hub",
    options: options
  )
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test

    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, type: :feature) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_in_container
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 3002
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::IntegrationHelpers, type: :system
  Capybara.default_max_wait_time = 10
  config.include Warden::Test::Helpers
  config.include Devise::Test::IntegrationHelpers, type: :request
end
