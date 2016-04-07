FactoryGirl.define do
  factory :item_type do
    name 'TestCar'
    base_fee 99
    fee_per_day 9
    disclaimer 'dont be dumb'
  end
end
