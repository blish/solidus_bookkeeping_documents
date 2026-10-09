RSpec.describe Spree::LineItem do
  describe "#pre_tax_price" do
    let(:order) { create(:invoiceable_order, :with_vat) }
    let(:line_item) { order.line_items.first }

    before do
      line_item.update!(quantity: 3)
      order.recalculate
    end

    it "is the unit price without VAT which is rounded" do
      expect(line_item.pre_tax_price).to eq(BigDecimal("8.40"))
    end
  end

  describe "#tax_total" do
    subject { order.line_items.first.tax_total }

    let(:order) { create(:invoiceable_order, :with_vat) }

    it { is_expected.to eq(BigDecimal("1.60")) }

    context "with VAT added to the price" do
      let(:order) { create(:invoiceable_order, :with_vat, vat_included_in_price: false) }

      it { is_expected.to eq(BigDecimal("1.90")) }
    end
  end

  describe "#vat_percent" do
    subject { order.line_items.first.vat_percent }

    let(:order) { create(:invoiceable_order, :with_vat) }

    it { is_expected.to eq(19) }

    context "without VAT" do
      let(:order) { create(:invoiceable_order) }

      it { is_expected.to be_nil }
    end
  end
end
