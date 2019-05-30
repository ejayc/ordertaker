FactoryGirl.define do
  factory :object_state_log do
    sequence(:object_id) { |n| n }
    sequence(:timestamp) { |n| Time.at(Time.zone.now.to_i + n) }

    trait :order do
      object_type "Order"
      object_changes "{\"status\":\"paid\",\"ship_date\":\"2017-01-18\",\"shipping_provider\":\"DHL\"}"
    end

    trait :invoice do
      object_type "Invoice"
      object_changes "{\"status\":\"paid\"}"
    end

    trait :product do
      object_type "Product"
      object_changes "{\"name\":\"Microphones\",\"price\":160,\"stock_levels\":1500}"
    end

    trait :purchase_order do
      object_type "PurchaseOrder"
      object_changes "{\"status\":\"paid\"}"
    end
  end
end
