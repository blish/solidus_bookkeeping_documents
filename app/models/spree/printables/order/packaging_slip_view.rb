module Spree
  class Printables::Order::PackagingSlipView < Printables::Order::InvoiceView
    class << self
      def document_number_prefix
        Spree::PrintInvoiceSetting.packaging_slip_number_prefix
      end
    end

    def name
      printable.ship_address.name
    end
  end
end
