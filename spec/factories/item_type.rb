FactoryGirl.define do
  factory :item_type do
    sequence(:name) { |n| "TestCar#{n}" }
    base_fee 100
    fee_per_day 10
    disclaimer 'dont be dumb'
  end

  factory :invalid_item_type, parent: :item_type do
    base_fee nil
  end
end
