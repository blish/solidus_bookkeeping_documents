module Spree
  class PrintInvoiceSetting < Preferences::Configuration
    preference :next_number,      :integer, default: nil
    preference :logo_path,        :string,  default: 'pdf-print/invoice-logo.jpg'
    preference :page_size,        :string,  default: 'LETTER'
    preference :page_layout,      :string,  default: 'landscape'
    preference :footer_left,      :string,  default: ''
    preference :footer_right,     :string,  default: ''
    preference :return_message,   :text,    default: ''
    preference :anomaly_message,  :text,    default: ''
    preference :use_footer,       :boolean, default: false
    preference :use_page_numbers, :boolean, default: false
    preference :logo_scale,       :integer, default: 50
    preference :font_face,        :string,  default: 'Helvetica'
    preference :font_size,        :integer, default: 9
    preference :store_pdf,        :boolean, default: false
    preference :storage_path,     :string,  default: 'tmp/invoice_prints'

    preference :invoice_number_prefix,        :string,  default: 'I-'
    preference :packaging_slip_number_prefix, :string,  default: 'P-'

    def page_sizes
      ::PDF::Core::PageGeometry::SIZES.keys
    end

    def page_layouts
      %w(landscape portrait)
    end

    def font_faces
      ::Prawn::Font::AFM::BUILT_INS.reject do |font|
        font =~ /zapf|symbol|bold|italic|oblique/i
      end
    end

    def font_sizes
      (7..14).to_a
    end

    def logo_scaling
      logo_scale.to_f / 100
    end
  end
end
