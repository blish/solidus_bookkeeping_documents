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
