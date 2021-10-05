module Spree
  module Admin
    class PrintInvoiceSettingsController < ResourceController
      private

      def load_resource
        @object ||= Spree::PrintInvoiceSetting.first || Spree::PrintInvoiceSetting.new
        super
      end

      def location_after_save
        spree.edit_admin_print_invoice_settings_path
      end
    end
  end
end
