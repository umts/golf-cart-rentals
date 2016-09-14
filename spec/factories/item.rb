# frozen_string_literal: true
FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "TestCar#{n}" }
    item_type_id 1
    uuid { SecureRandom.uuid }
  end

  factory :invalid_item, parent: :item do
    name nil
  end
end
