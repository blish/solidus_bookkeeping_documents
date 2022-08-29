class AddNameToSpreeBookkeepingDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_bookkeeping_documents, :name, :string
    add_index :spree_bookkeeping_documents, :name
  end
end
