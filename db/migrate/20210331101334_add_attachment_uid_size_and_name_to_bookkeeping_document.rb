class AddAttachmentUidSizeAndNameToBookkeepingDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_bookkeeping_documents, :attachment_uid, :string
    add_column :spree_bookkeeping_documents, :attachment_name, :string
    add_column :spree_bookkeeping_documents, :attachment_size, :string
  end
end
