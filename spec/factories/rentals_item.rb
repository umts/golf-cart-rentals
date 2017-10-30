# frozen_string_literal: true
FactoryGirl.define do
  factory :rentals_item do
    # no association to :rental, that would create an infinate loop
    association :item
    association :item_type
    reservation_id { SecureRandom.uuid }
  end
end
