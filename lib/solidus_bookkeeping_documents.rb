require "solidus_core"
require "solidus_backend"
require "solidus_bookkeeping_documents/deprecation"
require "solidus_bookkeeping_documents/engine"
require "solidus_bookkeeping_documents/version"
require "prawn-rails"
require "solidus_bookkeeping_documents/prawn_rails_configuration"

module Spree
  module PrintInvoice
    def self.solidus_menu_items
      @@solidus_menu_items ||= [
        ::Spree::BackendConfiguration::MenuItem.new(
          label: :documents,
          icon: :file,
          url: "/admin/bookkeeping_documents",
          condition: -> {
            can?(:admin, :bookkeeping_documents)
          },
          partial: "spree/admin/shared/sub_menu/documents",
          match_path: /bookkeeping_documents|bookkeeping_exports/
        )
      ]
    end
  end
end
