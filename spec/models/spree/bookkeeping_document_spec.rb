RSpec.describe Spree::BookkeepingDocument do
  let(:printable) { Spree::Order.new }
  let(:template) { "invoice" }

  subject { Spree::BookkeepingDocument.new(printable: printable, template: "invoice") }

  describe "attributes" do
    it { is_expected.to respond_to(:printable) }
    it { is_expected.to respond_to(:template) }

    # These attributes are only stored for sorting and searching.
    # Consequently, I would hope that a view class implements methods for
    # all of them.

    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:number) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:firstname) }
    it { is_expected.to respond_to(:lastname) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:total) }
  end

  describe "#view" do
    it { is_expected.to respond_to(:view) }

    context "with an order as printable" do
      it "is an Spree::Printables::Order::InvoiceView" do
        expect(subject.view).to be_a(Spree::Printables::Order::InvoiceView)
      end
    end
  end

  describe "#pdf" do
    subject(:document) { Spree::BookkeepingDocument.create(printable: printable, template: "invoice") }

    context "with an order" do
      let(:printable) { create :invoiceable_order }

      it "creates a PDF" do
        expect(subject.pdf).to match(/%PDF-1.\d/)
      end

      it "PDF has correct filename" do
        subject.pdf
        expect(document.attachment.name).to match("#{document.number}.pdf")
      end
    end

    context "with an invalid order" do
      let(:printable) { create(:invoiceable_order, ship_address: build(:address, name: nil)) }

      it "raises error" do
        expect { subject.pdf }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#file_name" do
    let(:document) { Spree::BookkeepingDocument.new }

    subject(:file_name) { document.file_name }

    it "is document number with PDF extension" do
      is_expected.to eq("#{document.number}.pdf")
    end
  end

  describe "#next_document_number" do
    let(:address) { FactoryBot.create(:address) }

    let(:printable) do
      Spree::Order.new(bill_address: address, ship_address: address)
    end

    context "if a document_number is present" do
      before do
        doc = Spree::BookkeepingDocument.create!(
          printable: printable,
          template: "invoice",
        )
        doc.update_column(:document_number, 41)
        subject.save!
      end

      it "returns the document_number incremented by one" do
        expect(subject.document_number).to eq(42)
      end
    end

    context "if a document_number_prefix is present" do
      before do
        doc = Spree::BookkeepingDocument.create!(
          printable: printable,
          template: "invoice",
        )
        doc.update_columns(document_number: 411, document_number_prefix: "I-")
        doc = Spree::BookkeepingDocument.create!(
          printable: printable,
          template: "packaging_slip",
        )
        doc.update_columns(document_number: 412, document_number_prefix: "P-")
        subject.save!
      end

      it "returns the document_number incremented by one" do
        expect(subject.document_number).to eq(412)
        expect(subject.document_number).to_not eq(413)
      end
    end

    context "if document_number is nil" do
      subject(:document) do
        Spree::BookkeepingDocument.create!(
          printable: printable,
          template: "invoice",
          document_number: nil,
        )
      end

      context "and next_number is configured" do
        before do
          allow(Spree::PrintInvoiceSetting).to receive(:next_number) { 11 }
        end

        it "returns the next number from settings" do
          expect(document.document_number).to eq(11)
        end
      end

      context "and next_number is not configured" do
        before do
          allow(Spree::PrintInvoiceSetting).to receive(:next_number) { nil }
        end

        it "returns 1" do
          expect(document.document_number).to eq(1)
        end
      end
    end
  end

  describe "#formatted_number" do
    let(:address) { FactoryBot.create(:address) }

    let(:printable) do
      Spree::Order.new(bill_address: address, ship_address: address)
    end

    subject(:document) do
      Spree::BookkeepingDocument.create!(
        printable: printable,
        template: "invoice",
        document_number: nil,
      )
    end

    before do
      allow(Spree::PrintInvoiceSetting).to receive(:next_number) { 77 }
      allow(Spree::PrintInvoiceSetting).to receive(:invoice_number_prefix) { "INVOICE" }
    end

    context "when using a NumberFormatter" do
      before do
        class Spree::PrintInvoice::NumberFormatter
          attr_reader :prefix, :number

          def initialize(prefix, number)
            @prefix = prefix
            @number = number
          end

          def to_s
            "MY-NICE-#{prefix}-#{number}"
          end
        end
      end

      it "returns a nicely formatted number" do
        expect(document.formatted_number).to eq("MY-NICE-INVOICE-77")
      end
    end

    context "when using no formatter" do
      before do
        Spree::PrintInvoice.send(:remove_const, "NumberFormatter")
      end

      it "returns a joined number" do
        expect(document.formatted_number).to eq("INVOICE77")
      end
    end
  end

  describe "validations" do
    let(:pdf) { Spree::BookkeepingDocument.new }
    it "is not valid without aa printable" do
      expect(pdf).not_to be_valid
    end
  end

  describe "method_missing" do
    it "sends stuff that the view knows to the view" do
      expect_any_instance_of(Spree::Printables::Order::InvoiceView).to receive(:items)
      subject.items
    end

    it "accurately reports missing methods as missing" do
      expect do
        subject.something_that_is_not_known
      end.to raise_error NoMethodError
    end
  end
end
