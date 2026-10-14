module Spree
  class ZugferdInvoice
    # BT-24 specification identifier, mandatory per BR-01.
    # @see https://github.com/ConnectingEurope/eInvoicing-EN16931
    # @see https://www.ferd-net.de/publikationen-produkte/publikationen/detailseite/zugferd-252-english
    CUSTOMIZATION_ID = "urn:cen.eu:en16931:2017"
    # BT-130 unit of measure, mandatory per BR-23.
    # @see https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/Registry+of+supporting+artefacts+to+implement+EN16931
    UNIT_CODE = "C62"
    # BT-105 document level charge reason code for shipping. UNTDID 7161 "Freight service".
    SHIPPING_REASON_CODE = "FC"

    class Error < StandardError; end

    attr_reader :document, :order

    def initialize(document)
      @document = document
      @order = document.printable
    end

    def supported?
      order.is_a?(Spree::Order) && document.template == "invoice"
    end

    def generate
      raise Error, "#{document.template_name} does not support e-invoices" unless supported?
      raise Error, "e-invoices do not support order level adjustments" if order.adjustments.nonzero.any?

      untaxed = (order.line_items + shipments).find { |item| item.vat_percent.nil? }
      raise Error, "e-invoices need exactly one VAT rate per item, #{untaxed.class.name} #{untaxed.id} has none or several" if untaxed

      Zugpferd::CII::Writer.new.write(invoice)
    end

    def embed(pdf)
      xml = generate

      Dir.mktmpdir do |dir|
        input_path = File.join(dir, "invoice.pdf")
        output_path = File.join(dir, "zugferd_invoice.pdf")
        File.binwrite(input_path, pdf)

        Zugpferd::PDF::Embedder.new.embed(pdf_path: input_path, xml: xml, output_path: output_path)
        File.binread(output_path)
      end
    end

    private

    def invoice
      Zugpferd::Model::Invoice.new(
        number: document.number,
        issue_date: document.date,
        currency_code: order.currency,
        customization_id: CUSTOMIZATION_ID,
        delivery_date:,
        seller:,
        buyer:,
        line_items:,
        allowance_charges:,
        tax_breakdown:,
        monetary_totals:
      )
    end

    def delivery_date
      order.shipments.filter_map(&:shipped_at).max&.to_date
    end

    def seller
      address = order.store.address
      raise Error, "e-invoices need a seller VAT id on the store address" if address&.vat_id.blank?

      Zugpferd::Model::TradeParty.new(
        name: order.store.name,
        vat_identifier: address.vat_id,
        postal_address: postal_address(address)
      )
    end

    def buyer
      address = order.bill_address
      Zugpferd::Model::TradeParty.new(
        name: address.name,
        vat_identifier: address.vat_id.presence,
        postal_address: postal_address(address)
      )
    end

    def postal_address(address)
      Zugpferd::Model::PostalAddress.new(
        country_code: address.country.iso,
        street_name: [address.address1, address.address2].compact_blank.join(", "),
        city_name: address.city,
        postal_zone: address.zipcode
      )
    end

    def line_items
      @_line_items ||= order.line_items.each_with_index.map do |line_item, index|
        Zugpferd::Model::LineItem.new(
          id: (index + 1).to_s,
          invoiced_quantity: line_item.quantity,
          unit_code: UNIT_CODE,
          line_extension_amount: line_item.total_excluding_vat,
          item: Zugpferd::Model::Item.new(
            name: line_item.variant.name,
            sellers_identifier: line_item.variant.sku,
            tax_category: category_code(line_item.vat_percent),
            tax_percent: line_item.vat_percent
          ),
          price: Zugpferd::Model::Price.new(amount: line_item.pre_tax_price)
        )
      end
    end

    def allowance_charges
      @_allowance_charges ||= shipments.map do |shipment|
        Zugpferd::Model::AllowanceCharge.new(
          charge_indicator: true,
          amount: shipment.total_excluding_vat,
          reason_code: SHIPPING_REASON_CODE,
          tax_category_code: category_code(shipment.vat_percent),
          tax_percent: shipment.vat_percent,
          currency_code: order.currency
        )
      end
    end

    def tax_breakdown
      @_tax_breakdown ||= begin
        subtotals = (order.line_items + shipments).group_by(&:vat_percent).map do |percent, items|
          Zugpferd::Model::TaxSubtotal.new(
            taxable_amount: items.sum(&:total_excluding_vat),
            tax_amount: items.sum(&:tax_total),
            category_code: category_code(percent),
            percent: percent,
            currency_code: order.currency
          )
        end

        Zugpferd::Model::TaxBreakdown.new(tax_amount: subtotals.sum(&:tax_amount), currency_code: order.currency, subtotals: subtotals)
      end
    end

    def monetary_totals
      line_total = line_items.sum(&:line_extension_amount)
      charge_total = allowance_charges.sum(&:amount)
      tax_exclusive_amount = line_total + charge_total

      Zugpferd::Model::MonetaryTotals.new(
        line_extension_amount: line_total,
        charge_total_amount: (charge_total if allowance_charges.any?),
        tax_exclusive_amount: tax_exclusive_amount,
        tax_inclusive_amount: tax_exclusive_amount + tax_breakdown.tax_amount,
        payable_amount: order.total
      )
    end

    # include only shipments that would effect allowance_charges entries
    # if the shipment is zero it does not have an effect on invoice totals
    def shipments
      @_shipments ||= order.shipments.reject { |shipment| shipment.total_excluding_vat.zero? }
    end

    # VAT category code "S" (standard rated), or "Z" for a 0 % rate.
    def category_code(percent)
      percent.zero? ? "Z" : "S"
    end
  end
end
