class AddInvoiceLogoUidToBookkeepingDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_bookkeeping_documents, :invoice_logo_uid, :string
  end
end
