# frozen_string_literal: true
FactoryBot.define do
  factory :rentals_item do
    # no association to :rental, that would create an infinite loop
    association :item
    reservation_id { SecureRandom.uuid }
    after(:build) do |rental_item|
      # automatically set the item type to the same as the item
      rental_item.item_type = rental_item.item.item_type
    end
  end
end
