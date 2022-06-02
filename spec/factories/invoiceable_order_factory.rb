FactoryBot.define do
  factory :invoiceable_order, class: Spree::Order do
    user
    bill_address { build(:address, name: "Jane Doe") }
    ship_address { build(:address, name: "John Doe") }
    completed_at nil
    email { user.email }
    state "confirm"
    store

    transient do
      line_items_count 1
      line_items_price 10
      shipment_cost 100
    end

    after(:create) do |order, evaluator|
      create_list(:line_item, evaluator.line_items_count, order: order, price: evaluator.line_items_price)
      order.line_items.reload

      create(:shipment, order: order, cost: evaluator.shipment_cost)
      order.shipments.reload
      order.complete!
    end
  end
end
