class AddDocumentNumberToSpreeBookkeepingDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_bookkeeping_documents, :document_number, :integer
    add_column :spree_bookkeeping_documents, :document_number_prefix, :string
    add_index :spree_bookkeeping_documents, [:document_number, :document_number_prefix],
      unique: true, name: "spree_bookkeeping_documents_document_number_idx"
  end
end
