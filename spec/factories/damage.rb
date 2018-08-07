# frozen_string_literal: true
FactoryBot.define do
  factory :damage do
    location 'outside'
    description 'broken stuff'
    occurred_on Date.today
    estimated_cost 1
    association :incurred_incidental, factory: :incurred_incidental
  end

  factory :invalid_damage, parent: :damage do
    location nil
  end
end
