RSpec.describe Spree::Order do
  it do
    is_expected.to have_many(:bookkeeping_documents)
      .dependent(:destroy)
      .inverse_of(:printable)
  end

  it do
    is_expected.to have_one(:invoice)
      .class_name("Spree::BookkeepingDocument")
      .conditions(template: "invoice")
  end

  it do
    is_expected.to have_one(:packaging_slip)
      .class_name("Spree::BookkeepingDocument")
      .conditions(template: "packaging_slip")
  end

  describe "delegates" do
    let(:order) { Spree::Order.new }
    let(:invoice) { Spree::BookkeepingDocument.new(printable: order, template: "invoice") }

    before do
      allow(order).to receive(:invoice) { invoice }
    end

    describe "#invoice_number" do
      it "calls invoice" do
        expect(invoice).to receive(:number)
        order.invoice_number
      end
    end

    describe "#invoice_date" do
      it "calls invoice" do
        expect(invoice).to receive(:date)
        order.invoice_date
      end
    end
  end

  describe "checkout flow" do
    let(:order) { create(:order_ready_to_complete) }

    it "creates a new invoice when completing the order" do
      expect do
        order.complete!
      end.to change { Spree::BookkeepingDocument.count }
    end

    it "prevents #invoice_for_order from creating too many documents" do
      order.complete!
      expect do
        order.invoice_for_order
      end.to_not change { Spree::BookkeepingDocument.count }
    end
  end

  describe "destruction" do
    let!(:order) { create :invoiceable_order }

    context "when destroyed" do
      before do
        order.shipments.map(&:pend!)
      end

      it "also destroys the invoice" do
        expect(Spree::BookkeepingDocument.count).not_to eq(0)
        order.destroy!
        expect(Spree::BookkeepingDocument.count).to eq(0)
      end
    end
  end
end
