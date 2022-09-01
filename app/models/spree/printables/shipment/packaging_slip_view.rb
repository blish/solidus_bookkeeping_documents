module Spree
  class Printables::Shipment::PackagingSlipView
    class << self
      def document_number_prefix
        Spree::PrintInvoiceSetting.packaging_slip_number_prefix
      end
    end

    attr_reader :shipment

    def initialize(shipment)
      @shipment = shipment
    end

    def display_number
      shipment.number
    end

    def date
      shipment.shipped_at
    end

    def name
      shipment.order.ship_address.name
    end
  end
end
