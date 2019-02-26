# frozen_string_literal: true
FactoryBot.define do
  factory :rentals_item do
    # no association to :rental, that would create an infinite loop
    item_type
  end
end
