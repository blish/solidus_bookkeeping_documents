require "spec_helper"

RSpec.describe Spree::Printables::Order::PackagingSlipView do
  let(:printable) { Spree::Order.new }
  let(:document) { Object.new }
  let(:packing_slip_view) { described_class.new(printable, document) }

  describe "#name" do
    it "call name on orders ship address" do
      expect(printable).to receive(:ship_address) { double(name: "Jane Doe") }
      expect(packing_slip_view.name).to eq("Jane Doe")
    end
  end
end
