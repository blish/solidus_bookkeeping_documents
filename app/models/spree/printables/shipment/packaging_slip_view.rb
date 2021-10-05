module Spree
  class Printables::Shipment::PackagingSlipView

    class << self
      def document_number_prefix
        Spree::PrintInvoiceSetting.packaging_slip_number_prefix
      end
    end

    def initialize(shipment)
      @shipment = shipment
    end

    def display_number
      @shipment.number
    end

    def date
      @shipment.shipped_at
    end

    def shipment
      nil
    end
  end
end
