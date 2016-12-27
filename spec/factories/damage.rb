# frozen_string_literal: true
FactoryGirl.define do
  factory :damage do
    location "outside"
    description "broken stuff"
    occurred_on Date.today
    estimated_cost 1
    association :incurred_incidental
  end
end
