module SolidusBookkeepingDocuments::Spree::LineItemPatch
  include SolidusBookkeepingDocuments::Spree::VatPercent

  def pre_tax_price
    amount = total_excluding_vat / quantity
    # the round_to_two_places method is a private method in Calculator::DefaultTax
    BigDecimal(amount.to_s).round(2, BigDecimal::ROUND_HALF_UP)
  end

  def tax_total
    included_tax_total + additional_tax_total
  end
end

Spree::LineItem.prepend(SolidusBookkeepingDocuments::Spree::LineItemPatch)
