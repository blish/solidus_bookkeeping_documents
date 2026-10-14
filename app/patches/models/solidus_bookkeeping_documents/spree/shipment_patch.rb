module SolidusBookkeepingDocuments::Spree::ShipmentPatch
  include SolidusBookkeepingDocuments::Spree::VatPercent
end

Spree::Shipment.prepend(SolidusBookkeepingDocuments::Spree::ShipmentPatch)
