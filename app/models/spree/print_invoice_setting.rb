module Spree
  class PrintInvoiceSetting < Spree::Base
    preference :next_number,      :integer, default: nil
    preference :logo_path,        :string,  default: 'pdf-print/invoice-logo.jpg'
    preference :page_size,        :string,  default: 'A4'
    preference :page_layout,      :string,  default: 'portrait'
    preference :footer_left,      :string,  default: ''
    preference :footer_right,     :string,  default: ''
    preference :return_message,   :text,    default: ''
    preference :anomaly_message,  :text,    default: ''
    preference :use_footer,       :boolean, default: false
    preference :use_page_numbers, :boolean, default: false
    preference :logo_scale,       :integer, default: 50
    preference :font_face,        :string,  default: 'Helvetica'
    preference :font_size,        :integer, default: 9

    preference :invoice_number_prefix,        :string,  default: 'I-'
    preference :packaging_slip_number_prefix, :string,  default: 'P-'

    class << self
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

      def invoice_logo_path
        Rails.root.join("app", "assets", "images", logo_path)
      end

      def logo_scaling
        logo_scale.to_f / 100
      end

      private

      def method_missing(method_name, *args, &block)
        preference_name = method_name.to_s.sub(/(.+)=$/, '\1')
        if persisted_preferences&.has_preference?(preference_name)
          if method_name.to_s.end_with?("=")
            persisted_preferences.set_preference(preference_name, args.first)
          else
            persisted_preferences.get_preference(preference_name)
          end
        else
          super
        end
      end

      def respond_to_missing(*args)
        persisted_preferences&.has_preference?(args.first) || super
      end

      def persisted_preferences
        @persisted_preferences ||= first || create
      end
    end
  end
end
