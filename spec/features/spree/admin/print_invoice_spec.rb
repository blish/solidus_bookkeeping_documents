RSpec.feature "Admin print invoice feature" do
  stub_authorization!

  let!(:order) { create(:invoiceable_order) }

  scenario "shows documents button on order page." do
    visit spree.edit_admin_order_path(id: order.number)
    within('[data-hook="admin_order_tabs"]') do
      expect(page).to have_link I18n.t(:documents, scope: "spree.print_invoice")
    end
  end

  scenario "shows order number on documents list" do
    visit spree.admin_bookkeeping_documents_path
    within('[data-hook="admin_printables_index_rows"]') do
      expect(page).to have_link order.number
    end
  end

  context "with pdf file already present" do
    let(:pdf_file_path) { "spec/fixtures/invoice.pdf" }

    before do
      allow_any_instance_of(Spree::BookkeepingDocument).to receive(:pdf).and_return("")
    end

    scenario "sends the stored file." do
      visit spree.admin_bookkeeping_document_path(id: order.invoice.id, format: :pdf)
      expect(page.body).to eq(IO.binread(pdf_file_path))
    end
  end

  context "with pdf file not yet present" do
    scenario "sends the stored file." do
      visit spree.admin_bookkeeping_document_path(id: order.invoice.id, format: :pdf)
      order.reload
      expect(page.body).to eq(
        IO.binread(
          Rails.root.join("..", "..", "spec", "dummy", "uploads", "bookkeeping_documents", order.invoice.attachment_uid)
        )
      )
    end
  end # spec/dummy/tmp/order_prints/invoices/invoice-R679215110.pdf
end
