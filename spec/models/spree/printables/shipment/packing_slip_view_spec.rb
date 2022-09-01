require "spec_helper"

RSpec.describe Spree::Printables::Shipment::PackagingSlipView do
  let(:order) { Spree::Order.new }
  let(:shipment) { Spree::Shipment.new(order: order) }
  let(:packing_slip_view) { described_class.new(shipment) }

  describe "#name" do
    it "call name on shipments ship address" do
      expect(order).to receive(:ship_address) { double(name: "Jane Doe") }
      expect(packing_slip_view.name).to eq("Jane Doe")
    end
  end
end
