require 'deface'
require 'dragonfly'

module SolidusBookkeepingDocuments
  class Engine < Rails::Engine
    isolate_namespace Spree
    engine_name 'solidus_bookkeeping_documents'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer 'solidus_bookkeeping_documents.settings_tab' do
      Spree::BackendConfiguration::CONFIGURATION_TABS << :print_invoice_settings
    end

    class << self
      def activate
        cache_klasses = %W(#{config.root}/app/**/*_decorator*.rb)
        Dir.glob(cache_klasses) do |klass|
          Rails.configuration.cache_classes ? require(klass) : load(klass)
        end
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
