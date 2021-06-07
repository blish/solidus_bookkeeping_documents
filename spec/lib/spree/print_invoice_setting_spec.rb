RSpec.describe Spree::PrintInvoiceSetting do
  subject { described_class.new }

  describe '#page_sizes' do
    it 'has a list of page sizes' do
      expect(subject.page_sizes).to be_a(Array)
      expect(subject.page_sizes.size).to be(50)
    end
  end

  describe '#page_layouts' do
    it 'has a list of layouts' do
      expect(subject.page_layouts).to be_a(Array)
      expect(subject.page_layouts).to match_array %w(landscape portrait)
    end
  end

  describe '#font_faces' do
    it 'has a list of font faces' do
      expect(subject.font_faces).to be_a(Array)
      expect(subject.font_faces).to match_array %w(Courier Helvetica Times-Roman)
    end
  end

  describe '#font_sizes' do
    it 'has a list of font sizes' do
      expect(subject.font_sizes).to be_a(Array)
      expect(subject.font_sizes.first).to be(7)
      expect(subject.font_sizes.last).to be(14)
    end
  end

  describe '#logo_scaling' do
    it 'converts logo scale to percent' do
      subject.logo_scale = 100
      expect(subject.logo_scaling).to be(1.0)
    end
  end

  describe '#invoice_logo_path' do
    let(:logo_path) { Rails.root.join("app", "assets", "images", Spree::PrintInvoice::Config[:logo_path]) }
    it 'is set' do
      expect(subject.invoice_logo_path).to eq(logo_path)
      expect(Spree::PrintInvoice::Config.invoice_logo_path).to eq(logo_path)
    end
  end
end
