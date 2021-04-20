RSpec.feature 'Admin print invoice feature' do
  stub_authorization!

  let!(:order) { create(:invoiceable_order) }

  # disabled because a strange delegate/with_options bug in
  # spree/core/app/models/spree/stock/content_item.rb:12 (spree 3.1-stable)
  # scenario 'shows documents button on order page.' do
  #   visit spree.edit_admin_order_path(id: order.number)
  #   within('#sidebar') do
  #     expect(page).to have_link Spree.t(:documents, scope: :print_invoice)
  #   end
  # end

  context 'with pdf file already present' do
    let(:pdf_file_path) { 'spec/fixtures/invoice.pdf' }

    before do
      allow_any_instance_of(Spree::BookkeepingDocument).to receive(:pdf).and_return("")
    end

    scenario 'sends the stored file.' do
      visit spree.admin_bookkeeping_document_path(id: order.invoice.id, format: :pdf)
      expect(page.body).to eq(IO.binread(pdf_file_path))
    end
  end

  context 'with pdf file not yet present' do
    scenario 'sends the stored file.' do
      visit spree.admin_bookkeeping_document_path(id: order.invoice.id, format: :pdf)
      order.reload
      expect(page.body).to eq(
        IO.binread(
          Rails.root.join('..', '..', 'spec', 'dummy', 'uploads', 'bookkeeping_documents', "#{order.invoice.attachment_uid}")
        )
      )
    end
  end # spec/dummy/tmp/order_prints/invoices/invoice-R679215110.pdf
end
