require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups(assets: %w(development test)))

begin
  require 'spree_frontend'
rescue LoadError
  # spree_frontend is not available.
end
begin
  require 'spree_backend'
rescue LoadError
  # spree_backend is not available.
end
begin
  require 'spree_api'
rescue LoadError
  # spree_api is not available.
end
require 'solidus_bookkeeping_documents'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end

