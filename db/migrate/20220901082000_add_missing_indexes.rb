class AddMissingIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :spree_bookkeeping_documents, :email
    add_index :spree_bookkeeping_documents, :number
  end
end
