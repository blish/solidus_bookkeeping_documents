Spree::Backend::Config.configure do |config|
  config.menu_items << config.class::MenuItem.new(
    [:documents, :bookkeeping_documents, :bookkeeping_exports],
    :file,
    url: "/admin/bookkeeping_documents",
    condition: -> {
      can?(:admin, :bookkeeping_documents)
    },
    partial: "spree/admin/shared/sub_menu/documents",
  )
end

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
