RSpec.describe Spree::Printables::Order::InvoiceView do
  let(:printable) { Spree::Order.new }
  let(:document) { Object.new }
  let(:invoice_view) { Spree::Printables::Order::InvoiceView.new(printable, document) }

  describe "#bill_address" do
    it "calls the orders bill address" do
      expect(printable).to receive(:bill_address)
      invoice_view.bill_address
    end
  end

  describe "#ship_address" do
    it "calls the orders ship address" do
      expect(printable).to receive(:ship_address)
      invoice_view.ship_address
    end
  end

  describe "#tax_address" do
    it "calls the orders tax address" do
      expect(printable).to receive(:tax_address)
      invoice_view.tax_address
    end
  end

  describe "#items" do
    it "calls line items on the order" do
      expect(printable).to receive(:line_items) { [create(:line_item)] }
      invoice_view.items
    end
  end

  describe "#name" do
    it "call name on orders bill address" do
      expect(printable).to receive(:bill_address) { double(name: "Jane Doe") }
      expect(invoice_view.name).to eq("Jane Doe")
    end
  end

  describe "#item_total" do
    it "calls the orders item total" do
      expect(printable).to receive(:item_total)
      invoice_view.item_total
    end
  end

  describe "#adjustments" do
    let(:all_adjustments) { [] }
    let(:eligible) { [] }

    it "calls all_adjustments on the order" do
      expect(printable).to receive(:all_adjustments) { all_adjustments }
      expect(all_adjustments).to receive(:eligible) { eligible }

      invoice_view.adjustments
    end
  end

  describe "#shipments" do
    it "calls shipments on the order" do
      expect(printable).to receive(:shipments)
      invoice_view.shipments
    end
  end

  describe "#total" do
    it "calls shipments on the order" do
      expect(printable).to receive(:total)
      invoice_view.total
    end
  end

  describe "#payments" do
    it "calls payments on the order" do
      expect(printable).to receive(:payments)
      invoice_view.payments
    end
  end
end
