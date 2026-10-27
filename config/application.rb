require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module MemorialApp
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    
    config.time_zone = 'Brasilia'
    config.i18n.default_locale = 'pt-BR'
    
    config.secret_key_base = ENV.fetch("SECRET_KEY_BASE") { "a" * 128 }
    
    # Mongoid
    Mongoid.load!("./config/mongoid.yml") if File.exist?("./config/mongoid.yml")
  end
end
