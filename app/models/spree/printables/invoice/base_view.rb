include Forwardable

module Spree
  class Printables::Invoice::BaseView < Printables::BaseView
    extend Forwardable
    extend Spree::DisplayMoney

    attr_reader :printable

    money_methods :item_total, :total

    class << self
      def document_number_prefix
        Spree::PrintInvoiceSetting.invoice_number_prefix
      end
    end

    def bill_address
      raise NotImplementedError, "Please implement bill_address"
    end

    def ship_address
      raise NotImplementedError, "Please implement ship_address"
    end

    def tax_address
      raise NotImplementedError, "Please implement tax_address"
    end

    def items
      raise NotImplementedError, "Please implement items"
    end

    def item_total
      raise NotImplementedError, "Please implement item_total"
    end

    def adjustments
      adjustments = []
      all_adjustments.group_by(&:label).each do |label, adjustment_group|
        adjustments << Spree::Printables::Invoice::Adjustment.new(
          label: label,
          amount: adjustment_group.map(&:amount).sum
        )
      end
      adjustments
    end

    def shipments
      raise NotImplementedError, "Please implement shipments"
    end

    def payments
      raise NotImplementedError, "Please implement payments"
    end

    def shipping_methods
      shipments.map(&:shipping_method).map(&:name)
    end

    def number
      document.number
    end
  end
end
