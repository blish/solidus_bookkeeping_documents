RSpec.describe Spree::PrintInvoiceSetting do
  subject { described_class }

  describe "#page_sizes" do
    it "has a list of page sizes" do
      expect(subject.page_sizes).to be_a(Array)
      expect(subject.page_sizes.size).to be(50)
    end
  end

  describe "#page_layouts" do
    it "has a list of layouts" do
      expect(subject.page_layouts).to be_a(Array)
      expect(subject.page_layouts).to match_array %w(landscape portrait)
    end
  end

  describe "#font_faces" do
    it "has a list of font faces" do
      expect(subject.font_faces).to be_a(Array)
      expect(subject.font_faces).to match_array ["Serif", "Sans Serif", "Monospace"]
    end
  end

  describe "#font_sizes" do
    it "has a list of font sizes" do
      expect(subject.font_sizes).to be_a(Array)
      expect(subject.font_sizes.first).to be(7)
      expect(subject.font_sizes.last).to be(14)
    end
  end

  describe "#logo_scaling" do
    it "converts logo scale to percent" do
      subject.logo_scale = 100
      expect(subject.logo_scaling).to be(1.0)
    end
  end

  describe "#invoice_logo_path" do
    let(:logo_path) { Rails.root.join("app", "assets", "images", Spree::PrintInvoiceSetting.logo_path) }

    it "is set" do
      expect(subject.invoice_logo_path).to eq(logo_path)
      expect(Spree::PrintInvoiceSetting.invoice_logo_path).to eq(logo_path)
    end
  end

  it "has defaults" do
    expect(subject.next_number).to eq(nil)
    expect(subject.logo_path).to eq("pdf-print/invoice-logo.jpg")
    expect(subject.page_size).to eq("A4")
    expect(subject.page_layout).to eq("portrait")
    expect(subject.footer_left).to eq(nil)
    expect(subject.footer_right).to eq(nil)
    expect(subject.return_message).to eq(nil)
    expect(subject.anomaly_message).to eq(nil)
    expect(subject.use_footer).to eq(nil)
    expect(subject.use_page_numbers).to eq(nil)
    expect(subject.logo_scale).to eq(50)
    expect(subject.font_face).to eq("Helvetica")
    expect(subject.font_size).to eq(9)
  end

  context "defaults" do
    let(:new_defaults) do
      {
        next_number: 666,
        logo_path: "rechnung.png",
        page_size: "A1",
        page_layout: "landscape",
        footer_left: "left",
        footer_right: "right",
        return_message: "return",
        anomaly_message: "anomaly",
        use_footer: true,
        use_page_numbers: true,
        logo_scale: 500,
        font_face: "Times-Roman",
        font_size: 11,
        invoice_number_prefix: "RE",
        packaging_slip_number_prefix: "L",
      }
    end

    around do |example|
      old_defaults = described_class.defaults
      described_class.defaults = new_defaults
      example.run
      described_class.defaults = old_defaults
    end

    it "can be changed" do
      new_defaults.each do |key, val|
        expect(subject.send(key)).to eq(val)
      end
    end
  end
end
