# frozen_string_literal: true
FactoryGirl.define do
  factory :item_type do
    sequence(:name) { |n| "TestCar#{n}" }
    base_fee 100
    fee_per_day 10
    uuid { SecureRandom.uuid }
  end

  factory :invalid_item_type, parent: :item_type do
    base_fee nil
  end
end
