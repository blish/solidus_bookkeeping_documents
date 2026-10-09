module SolidusBookkeepingDocuments::Spree::VatPercent
  # the applied VAT rate in percent, or nil unless exactly one VAT rate applies
  # @return [BigDecimal, nil]
  def vat_percent
    rates = adjustments.select(&:tax?).map(&:source).uniq
    rates.first.amount * 100 if rates.one?
  end
end
