FactoryBot.define do
  factory :invoiceable_order, class: Spree::Order do
    user
    bill_address { create(:address, name: "Jane Doe", country:) }
    ship_address { create(:address, name: "John Doe", country:) }
    completed_at { nil }
    email { user.email }
    state { "confirm" }
    store

    transient do
      line_items_count { 1 }
      line_items_price { 10 }
      shipment_cost { 100 }
      country do
        Spree::Country.find_by(iso: "DE") || create(:country, iso: "DE", states_required: false)
      end
    end

    after(:create) do |order, evaluator|
      create_list(:line_item, evaluator.line_items_count, order: order, price: evaluator.line_items_price)
      order.line_items.reload

      create(:shipment, order: order, cost: evaluator.shipment_cost)
      order.shipments.reload
      order.complete!
    end

    trait :with_vat do
      transient do
        vat_rate { 0.19 }
        vat_included_in_price { true }
        seller_vat_id { "DE123456789" }
      end

      after(:create) do |order, evaluator|
        order.store.update!(address: create(:address, vat_id: evaluator.seller_vat_id, country: order.tax_address.country))

        tax_category = order.line_items.first.tax_category
        zone = create(:zone, countries: [order.tax_address.country])
        create(:tax_rate, zone:, amount: evaluator.vat_rate, included_in_price: evaluator.vat_included_in_price, tax_categories: [tax_category])

        order.shipments.each { |shipment| shipment.shipping_method.update!(tax_category:) }
        order.recalculate
      end
    end
  end
end
