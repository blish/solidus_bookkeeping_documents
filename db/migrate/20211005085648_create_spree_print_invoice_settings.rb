class CreateSpreePrintInvoiceSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_print_invoice_settings do |t|
      t.text :preferences
    end
  end
end
