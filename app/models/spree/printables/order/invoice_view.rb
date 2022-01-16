module Spree
  class Printables::Order::InvoiceView < Printables::Invoice::BaseView
    def_delegators :@printable,
                   :email,
                   :bill_address,
                   :ship_address,
                   :tax_address,
                   :item_total,
                   :total,
                   :payments,
                   :shipments

    def items
      printable.line_items.map do |item|
        Spree::Printables::Invoice::Item.new(
          sku: item.variant.sku,
          name: item.variant.name,
          options_text: item.variant.options_text,
          price: item.price,
          quantity: item.quantity,
          total: item.total,
        )
      end
    end

    def name
      printable.tax_address.name
    end

    def firstname
      name.split(/[[:space:]]/, 2).first
    end

    def lastname
      name.split(/[[:space:]]/, 2).last
    end

    private

    def all_adjustments
      printable.all_adjustments.eligible
    end
  end
end
