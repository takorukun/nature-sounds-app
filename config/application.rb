require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.default_locale = :ja
    config.to_prepare do
      Dir[Rails.root.join('app', 'models', '*_decorator.rb')].each { |f| require_dependency f }
    end
  end
end
