require "deface"
require "dragonfly"
require "solidus_support"

module SolidusBookkeepingDocuments
  class Engine < Rails::Engine
    isolate_namespace Spree
    engine_name "solidus_bookkeeping_documents"

    include SolidusSupport::EngineExtensions

    config.autoload_paths += %W(#{config.root}/lib)
  end
end
