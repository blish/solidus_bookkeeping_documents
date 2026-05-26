module Spree
  class PrintInvoiceSetting < Spree::Base
    include Spree::Preferences::Persistable

    preference :next_number, :integer, default: -> { defaults[:next_number] }
    preference :logo_path, :string, default: -> { defaults[:logo_path] }
    preference :page_size, :string, default: -> { defaults[:page_size] }
    preference :page_layout, :string, default: -> { defaults[:page_layout] }
    preference :footer_left, :string, default: -> { defaults[:footer_left] }
    preference :footer_right, :string, default: -> { defaults[:footer_right] }
    preference :return_message, :text, default: -> { defaults[:return_message] }
    preference :anomaly_message, :text, default: -> { defaults[:anomaly_message] }
    preference :use_footer, :boolean, default: -> { defaults[:use_footer] }
    preference :use_page_numbers, :boolean, default: -> { defaults[:use_page_numbers] }
    preference :logo_scale, :integer, default: -> { defaults[:logo_scale] }
    preference :font_face, :string, default: -> { defaults[:font_face] }
    preference :font_size, :integer, default: -> { defaults[:font_size] }

    preference :invoice_number_prefix, :string, default: -> { defaults[:invoice_number_prefix] }
    preference :packaging_slip_number_prefix, :string, default: -> { defaults[:packaging_slip_number_prefix] }

    class << self
      attr_accessor :defaults

      def page_sizes
        ::PDF::Core::PageGeometry::SIZES.keys
      end

      def page_layouts
        %w[landscape portrait]
      end

      def font_faces
        [
          "Serif",
          "Sans Serif",
          "Monospace"
        ]
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

      # Reset the memoized persisted preferences, so that the new settings will be loaded from the database again.
      def reset_persisted_preferences!
        @_persisted_preferences = nil
      end

      private

      def method_missing(method_name, *args, &block) # rubocop:disable Style/MissingRespondToMissing
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

      # Memoize the persisted preferences, so that we don't hit the database every time we access a preference.
      # Note: Make sure to call `reset_persisted_preferences!` after updating the settings.
      def persisted_preferences
        @_persisted_preferences ||= first || create
      end
    end

    def defaults
      self.class.defaults || {}
    end
  end
end
