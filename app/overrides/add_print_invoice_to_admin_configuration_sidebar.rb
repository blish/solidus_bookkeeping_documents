Deface::Override.new(
  virtual_path:  'spree/admin/shared/_settings_sub_menu',
  name:          'print_invoice_admin_configurations_menu',
  insert_bottom: '.admin-subnav',
  partial:       'spree/admin/shared/menu/print_settings_tab'
)
