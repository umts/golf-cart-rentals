# frozen_string_literal: true
FactoryGirl.define do
  factory :damage do
    association :rental, factory: :mock_rental
  end
end
