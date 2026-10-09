RSpec.describe Spree::ZugferdInvoice do
  let(:order) { create(:invoiceable_order, :with_vat, line_items_count: 2, line_items_price: 10) }
  let(:document) { order.invoice }
  let(:ns) { Zugpferd::CII::Mapping::NS }

  subject(:xml) { Nokogiri::XML(described_class.new(document).generate) }

  def text(xpath, node = xml)
    node.at_xpath(xpath, ns)&.text
  end

  def amount(xpath, node = xml)
    BigDecimal(text(xpath, node))
  end

  it "is a commercial invoice" do
    expect(xml.root.name).to eq("CrossIndustryInvoice")
    expect(text("//rsm:ExchangedDocument/ram:TypeCode")).to eq("380")
  end

  it "declares the EN 16931 guideline" do
    expect(text("//ram:GuidelineSpecifiedDocumentContextParameter/ram:ID")).to eq("urn:cen.eu:en16931:2017")
  end

  it "uses the document number and date" do
    expect(text("//rsm:ExchangedDocument/ram:ID")).to eq(document.number)
    expect(text("//rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString")).to eq(document.date.strftime("%Y%m%d"))
  end

  it "uses the order currency" do
    order.update_column(:currency, "EUR")
    expect(text("//ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode")).to eq("EUR")
  end

  describe "seller" do
    let(:seller) { xml.at_xpath("//ram:SellerTradeParty", ns) }

    it "is the store" do
      expect(text("ram:Name", seller)).to eq(order.store.name)
    end

    it "has the VAT id of the store address" do
      expect(text("ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']", seller)).to eq("DE123456789")
    end

    it "has the store address" do
      order.store.update!(address: create(:address, address1: "Hauptstr. 1", address2: "Hinterhaus", city: "Berlin", zipcode: "10115", vat_id: "DE999999999", country: order.bill_address.country))

      expect(text("ram:PostalTradeAddress/ram:LineOne", seller)).to eq("Hauptstr. 1, Hinterhaus")
      expect(text("ram:PostalTradeAddress/ram:CityName", seller)).to eq("Berlin")
      expect(text("ram:PostalTradeAddress/ram:PostcodeCode", seller)).to eq("10115")
      expect(text("ram:PostalTradeAddress/ram:CountryID", seller)).to eq("DE")
    end

    context "without store address" do
      before { order.store.update!(address: nil) }

      it "raises an error" do
        expect { xml }.to raise_error(Spree::ZugferdInvoice::Error, /seller VAT id/)
      end
    end

    context "without VAT id" do
      let(:order) { create(:invoiceable_order, :with_vat, seller_vat_id: nil) }

      it "raises an error" do
        expect { xml }.to raise_error(Spree::ZugferdInvoice::Error, /seller VAT id/)
      end
    end
  end

  describe "buyer" do
    let(:order) do
      country = Spree::Country.find_by(iso: "DE") || create(:country, iso: "DE", states_required: false)
      create(:invoiceable_order, :with_vat, bill_address: create(:address, name: "Jane Doe", address1: "Buyer Street 5", address2: nil, city: "Hamburg", zipcode: "20095", vat_id: "DE123456789", country:))
    end
    let(:buyer) { xml.at_xpath("//ram:BuyerTradeParty", ns) }

    it "is the bill address" do
      expect(text("ram:Name", buyer)).to eq("Jane Doe")
      expect(text("ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']", buyer)).to eq("DE123456789")
    end

    it "has the bill address as postal address" do
      expect(text("ram:PostalTradeAddress/ram:LineOne", buyer)).to eq("Buyer Street 5")
      expect(text("ram:PostalTradeAddress/ram:CityName", buyer)).to eq("Hamburg")
      expect(text("ram:PostalTradeAddress/ram:PostcodeCode", buyer)).to eq("20095")
      expect(text("ram:PostalTradeAddress/ram:CountryID", buyer)).to eq("DE")
    end

    context "without VAT id" do
      let(:order) { create(:invoiceable_order, :with_vat) }

      it "has no tax registration" do
        expect(buyer.at_xpath("ram:SpecifiedTaxRegistration", ns)).to be_nil
      end
    end
  end

  describe "line items" do
    let(:lines) { xml.xpath("//ram:IncludedSupplyChainTradeLineItem", ns) }

    it "has one line per order line item" do
      expect(lines.map { |line| text("ram:AssociatedDocumentLineDocument/ram:LineID", line) }).to eq(%w[1 2])
    end

    it "maps the order line item" do
      line_item = order.line_items.first
      line = lines.first

      expect(amount("ram:SpecifiedLineTradeDelivery/ram:BilledQuantity", line)).to eq(line_item.quantity)
      expect(line.at_xpath("ram:SpecifiedLineTradeDelivery/ram:BilledQuantity", ns)["unitCode"]).to eq("C62")
      expect(amount("ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount", line)).to eq(line_item.total_excluding_vat)
      expect(text("ram:SpecifiedTradeProduct/ram:Name", line)).to eq(line_item.variant.name)
      expect(text("ram:SpecifiedTradeProduct/ram:SellerAssignedID", line)).to eq(line_item.variant.sku)
      expect(amount("ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount", line)).to eq(line_item.pre_tax_price)
    end
  end

  describe "VAT" do
    let(:order) { create(:invoiceable_order, :with_vat, line_items_count: 3, line_items_price: 9.99, shipment_cost: 4.99) }
    let(:totals) { xml.at_xpath("//ram:SpecifiedTradeSettlementHeaderMonetarySummation", ns) }

    it "categorizes each line as standard rated" do
      taxes = xml.xpath("//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax", ns)
      expect(taxes.map { |tax| text("ram:CategoryCode", tax) }).to eq(%w[S S S])
      expect(taxes.map { |tax| amount("ram:RateApplicablePercent", tax) }).to all(eq(19))
    end

    it "adds the shipping as document level charge" do
      charge = xml.at_xpath("//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge", ns)
      expect(text("ram:ChargeIndicator/udt:Indicator", charge)).to eq("true")
      expect(text("ram:ReasonCode", charge)).to eq("FC")
      expect(amount("ram:ActualAmount", charge)).to eq(BigDecimal("4.19"))
      expect(text("ram:CategoryTradeTax/ram:CategoryCode", charge)).to eq("S")
      expect(amount("ram:CategoryTradeTax/ram:RateApplicablePercent", charge)).to eq(19)
    end

    it "uses the VAT charged by Solidus in the breakdown" do
      breakdown = xml.xpath("//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax", ns)
      expect(breakdown.size).to eq(1)
      expect(text("ram:CategoryCode", breakdown.first)).to eq("S")
      expect(amount("ram:RateApplicablePercent", breakdown.first)).to eq(19)
      expect(amount("ram:BasisAmount", breakdown.first)).to eq(BigDecimal("29.36"))
      expect(amount("ram:CalculatedAmount", breakdown.first)).to eq(order.included_tax_total)
    end

    it "sums up to the order total" do
      expect(amount("ram:LineTotalAmount", totals)).to eq(BigDecimal("25.17"))
      expect(amount("ram:ChargeTotalAmount", totals)).to eq(BigDecimal("4.19"))
      expect(amount("ram:TaxBasisTotalAmount", totals)).to eq(BigDecimal("29.36"))
      expect(amount("ram:TaxTotalAmount", totals)).to eq(BigDecimal("5.60"))
      expect(amount("ram:GrandTotalAmount", totals)).to eq(order.total)
      expect(amount("ram:DuePayableAmount", totals)).to eq(order.total)
    end

    it "orders the totals as required by the CII schema" do
      expect(totals.element_children.map(&:name)).to eq(%w[
        LineTotalAmount ChargeTotalAmount TaxBasisTotalAmount TaxTotalAmount GrandTotalAmount DuePayableAmount
      ])
    end

    context "with VAT added to the price" do
      let(:order) { create(:invoiceable_order, :with_vat, line_items_count: 3, line_items_price: 9.99, shipment_cost: 4.99, vat_included_in_price: false) }

      it "uses the prices as net amounts" do
        expect(amount("ram:TaxBasisTotalAmount", totals)).to eq(BigDecimal("34.96"))
        expect(amount("ram:TaxTotalAmount", totals)).to eq(order.additional_tax_total)
        expect(amount("ram:GrandTotalAmount", totals)).to eq(order.total)
        expect(amount("ram:DuePayableAmount", totals)).to eq(order.total)
      end
    end

    context "with free shipping" do
      let(:order) { create(:invoiceable_order, :with_vat, shipment_cost: 0) }

      it "has no shipping charge" do
        expect(xml.at_xpath("//ram:SpecifiedTradeAllowanceCharge", ns)).to be_nil
        expect(totals.at_xpath("ram:ChargeTotalAmount", ns)).to be_nil
      end
    end

    context "with an untaxed line item" do
      let(:order) { create(:invoiceable_order) }

      it "raises an error" do
        expect { xml }.to raise_error(Spree::ZugferdInvoice::Error, /VAT/)
      end
    end

    context "with an order level adjustment" do
      before do
        order.adjustments.create!(order:, label: "Discount", amount: -5)
      end

      it "raises an error" do
        expect { xml }.to raise_error(Spree::ZugferdInvoice::Error, /adjustment/)
      end
    end
  end

  describe "delivery date" do
    it "is missing without shipped shipments" do
      expect(xml.at_xpath("//ram:ActualDeliverySupplyChainEvent", ns)).to be_nil
    end

    context "with shipped shipments" do
      before do
        order.shipments.first.update_columns(shipped_at: Time.zone.local(2026, 10, 1, 12))
        create(:shipment, order:, cost: 0).update_columns(shipped_at: Time.zone.local(2026, 10, 3, 12))
        order.shipments.reload
      end

      it "is the date of the last shipment" do
        expect(text("//ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString")).to eq("20261003")
      end
    end
  end

  context "with a packaging slip" do
    let(:document) { order.packaging_slip }

    it "raises an error" do
      expect { xml }.to raise_error(Spree::ZugferdInvoice::Error)
    end
  end

  context "with an invoice of another printable" do
    let(:document) { Spree::BookkeepingDocument.new(printable: Spree::Shipment.new, template: "invoice") }

    it "raises an error" do
      expect { xml }.to raise_error(Spree::ZugferdInvoice::Error)
    end
  end

  describe "#supported?" do
    subject { described_class.new(document).supported? }

    context "with an order invoice" do
      it { is_expected.to be(true) }
    end

    context "with a packaging slip" do
      let(:document) { order.packaging_slip }

      it { is_expected.to be(false) }
    end

    context "with an invoice of another printable" do
      let(:document) { Spree::BookkeepingDocument.new(printable: Spree::Shipment.new, template: "invoice") }

      it { is_expected.to be(false) }
    end
  end

  describe "#embed" do
    subject(:pdf) { described_class.new(document).embed(document.render_pdf) }

    it "embeds the XML as factur-x.xml" do
      expect(embedded_files(pdf).keys).to eq(["factur-x.xml"])
      expect(embedded_files(pdf)["factur-x.xml"]).to eq(described_class.new(document).generate)
    end

    it "returns a PDF/A-3 with EN 16931 conformance level" do
      expect(xmp_metadata(pdf)).to include("pdfaid:part='3'")
      expect(xmp_metadata(pdf)).to include("EN 16931")
    end

    context "with a packaging slip" do
      let(:document) { order.packaging_slip }

      it "raises an error" do
        expect { pdf }.to raise_error(Spree::ZugferdInvoice::Error)
      end
    end
  end
end
