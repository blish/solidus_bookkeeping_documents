RSpec.describe Spree::Shipment do
  describe "#vat_percent" do
    subject { order.shipments.first.vat_percent }

    let(:order) { create(:invoiceable_order, :with_vat) }

    it { is_expected.to eq(19) }

    context "without VAT" do
      let(:order) { create(:invoiceable_order) }

      it { is_expected.to be_nil }
    end
  end
end
