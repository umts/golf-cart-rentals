# frozen_string_literal: true
FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "TestCar#{n}" }
    association :item_type
    uuid { SecureRandom.uuid }
  end

  factory :invalid_item, parent: :item do
    name { nil }
  end
end
