module Spree::PrintInvoice::OrderPatch
  def self.prepended(base)
    base.has_many :bookkeeping_documents, as: :printable, dependent: :destroy, inverse_of: :printable

    base.has_one :invoice,
      -> { where(template: "invoice") },
      class_name: "Spree::BookkeepingDocument",
      as: :printable

    base.has_one :packaging_slip,
      -> { where(template: "packaging_slip") },
      class_name: "Spree::BookkeepingDocument",
      as: :printable

    base.delegate :number, :date, to: :invoice, prefix: true

    # Create a new invoice before transitioning to complete
    #
    base.state_machine.before_transition to: :complete, do: :invoice_for_order
  end

  def invoice_for_order
    # Under some conditions this method could be called more than once.
    # We have to make sure that an invoice/packaging slip is never created more
    # than once for an order.
    ActiveRecord::Base.transaction do
      create_invoice unless invoice.present?
      create_packaging_slip unless packaging_slip.present?
    end
  end
end

Spree::Order.prepend(Spree::PrintInvoice::OrderPatch)
