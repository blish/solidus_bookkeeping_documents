Rails.application.config.after_initialize do
  Spree::Backend::Config.configure do |config|
    menu_item = if Spree.solidus_gem_version >= Gem::Version.new("4.2.0")
      # settings tab
      print_invoice_settings = Spree::BackendConfiguration::MenuItem.new(
        label: :print_invoice_settings,
        condition: -> { can?(:admin, :general_settings) },
        url: :edit_admin_print_invoice_settings_path,
        match_path: %r{print_invoice_settings}
      )
      config.menu_items.find { |item| item.label == :settings }&.children&.<< print_invoice_settings

      # main menu item
      ::Spree::BackendConfiguration::MenuItem.new(
        label: :documents,
        icon: config.admin_updated_navbar ? "ri-file-copy-2-line" : "file",
        url: -> {
          Spree::Core::Engine.routes.url_helpers.admin_bookkeeping_documents_path
        },
        condition: -> {
          can?(:admin, :bookkeeping_documents)
        },
        children: [
          ::Spree::BackendConfiguration::MenuItem.new(
            label: :invoices,
            url: -> {
              Spree::Core::Engine.routes.url_helpers.admin_bookkeeping_documents_path(q: {template_cont: "invoice"})
            },
            condition: -> {
              can?(:admin, :bookkeeping_documents)
            }
          ),
          ::Spree::BackendConfiguration::MenuItem.new(
            label: :packaging_slips,
            url: -> {
              Spree::Core::Engine.routes.url_helpers.admin_bookkeeping_documents_path(q: {template_cont: "packaging_slip"})
            },
            condition: -> {
              can?(:admin, :bookkeeping_documents)
            }
          )
        ],
        match_path: /bookkeeping_documents/
      )
    else
      # settings tab
      Spree::BackendConfiguration::CONFIGURATION_TABS << :print_invoice_settings

      # main menu item
      ::Spree::BackendConfiguration::MenuItem.new(
        [:documents, :bookkeeping_documents, :bookkeeping_exports],
        "file",
        url: "/admin/bookkeeping_documents",
        condition: -> {
          can?(:admin, :bookkeeping_documents)
        },
        partial: "spree/admin/shared/sub_menu/documents",
        match_path: /bookkeeping_documents/
      )
    end

    products_tab = config.menu_items.detect { |item| item.label == :products }
    config.menu_items.index(products_tab).tap do |index|
      config.menu_items.insert(index + 1, menu_item)
    end
  end
end

Rails.application.config.to_prepare do
  Spree::PrintInvoiceSetting.defaults = {
    logo_path: "pdf-print/invoice-logo.jpg",
    page_size: "A4",
    page_layout: "portrait",
    logo_scale: 50,
    font_face: "Sans Serif",
    font_size: 9,
    invoice_number_prefix: "I-",
    packaging_slip_number_prefix: "P-"
  }
end
