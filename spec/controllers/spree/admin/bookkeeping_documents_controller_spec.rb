RSpec.describe Spree::Admin::BookkeepingDocumentsController, type: :controller do
  stub_authorization!

  before do
    user = build(:admin_user)
    allow(controller).to receive(:try_spree_current_user).and_return(user)
  end

  describe "#show as :pdf" do
    context "an order invoice" do
      let!(:order) { create(:invoiceable_order) }
      let(:pdf) { order.invoice }

      context "with a valid image as logo" do
        before do
          Spree::PrintInvoiceSetting.logo_path = "logo/spree_50.png"
        end

        it "renders pdf" do
          get :show, params: {id: pdf.id}, format: :pdf
          expect(response).to be_successful
        end
      end

      context "with an invalid path as logo" do
        before do
          Spree::PrintInvoiceSetting.logo_path = "this/is/not_an_exisiting_image.png"
        end

        it "renders pdf" do
          get :show, params: {id: pdf.id}, format: :pdf
          expect(response).to be_successful
        end
      end
    end

    context "an order packaging slip" do
      let!(:order) { create(:invoiceable_order) }
      let(:pdf) { order.packaging_slip }

      it "renders pdf" do
        get :show, params: {id: pdf.id}, format: :pdf
        expect(response).to be_successful
      end
    end
  end

  describe "#index as :html" do
    let(:bills_address) do
      create(:address, name: "Bill Murray")
    end

    let(:joes_address) do
      create(:address, name: "Joe Dalton")
    end

    let!(:bills_order) do
      create :invoiceable_order,
        ship_address: bills_address,
        email: "bill@murray.net"
    end

    let!(:joes_order) do
      create :invoiceable_order,
        ship_address: joes_address,
        email: "joe@dalton.com"
    end

    context "from the Spree::Orders#edit view" do
      before { get(:index, params: {order_id: bills_order.number}) }

      it "returns 200 success" do
        expect(response).to be_successful
      end

      it "assigns @bookkeeping_documents" do
        expect(assigns(:bookkeeping_documents)).to be_a(ActiveRecord::Relation)
      end

      it "includes bill's order, but not joe's order" do
        expect(assigns(:bookkeeping_documents)).not_to include(joes_order.invoice)
        expect(assigns(:bookkeeping_documents)).to include(bills_order.invoice)
      end
    end

    context "from the the side bar" do
      before { get :index, params: {} }

      it "returns 200 success" do
        expect(response).to be_successful
      end

      it "assigns @bookkeeping_documents" do
        expect(assigns(:bookkeeping_documents)).to be_a(ActiveRecord::Relation)
      end

      it "includes both bill and joes order" do
        expect(assigns(:bookkeeping_documents)).to include(joes_order.invoice)
        expect(assigns(:bookkeeping_documents)).to include(bills_order.invoice)
      end
    end
  end

  describe "#destroy" do
    let(:order) { create(:invoiceable_order) }
    let(:invoice) { order.invoice }

    it "removes the attachment" do
      invoice.pdf # Access pdf to create the file
      delete :destroy, params: {id: invoice.id}
      expect(response).to redirect_to(spree.admin_bookkeeping_documents_path)
      expect(invoice.reload.attachment_uid).to be_nil
    end
  end
end
