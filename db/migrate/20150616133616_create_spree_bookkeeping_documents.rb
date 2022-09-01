class CreateSpreeBookkeepingDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_bookkeeping_documents do |t|
      t.references :printable, polymorphic: true, index: { name: "spree_bookkeeping_documents_printable_idx" }
      t.string :template
      t.string :number
      t.string :name, index: true
      t.string :email
      t.decimal :total, precision: 12, scale: 2
      t.integer :document_number
      t.string :document_number_prefix
      t.string :attachment_uid
      t.string :attachment_name
      t.string :attachment_size

      t.timestamps null: false
    end
    add_index :spree_bookkeeping_documents, [:document_number, :document_number_prefix],
      unique: true, name: "spree_bookkeeping_documents_document_number_idx"
  end
end
