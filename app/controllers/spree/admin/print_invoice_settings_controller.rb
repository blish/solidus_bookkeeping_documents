module Spree
  module Admin
    class PrintInvoiceSettingsController < ResourceController
      update.after :reset_persisted_preferences

      private

      def load_resource
        @object ||= Spree::PrintInvoiceSetting.first || Spree::PrintInvoiceSetting.new
        super
      end

      def location_after_save
        spree.edit_admin_print_invoice_settings_path
      end

      # After updating the settings, we need to reset the memoized preferences,
      # so that the new settings will be loaded from the database again.
      def reset_persisted_preferences
        Spree::PrintInvoiceSetting.reset_persisted_preferences!
      end
    end
  end
end
