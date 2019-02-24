# frozen_string_literal: true
FactoryBot.define do
  factory :rental do
    association :creator, factory: :user
    renter { creator } # set renter equal to creator by default
    start_time { Time.current }
    end_time { (Time.current + 1.day) }

    after(:build) do |rental|
      # a rental is invalid if its renter doesn't have permission to assign.
      # a user can't have permissions for anything if they're not persisted.
      rental.renter.save if rental.renter.present?
      if rental.rentals_items.empty?
        item = create :item
        rentals_item = build(:rentals_item, item: item)
        rental.rentals_items << rentals_item
      end
    end

  end

  factory :rental_without_items, parent: :rental do
    after(:build) do |rental|
      rental.rentals_items = []
    end
  end

  factory :invalid_rental, parent: :mock_rental do
    start_time { nil }
  end

  factory :new_rental, parent: :mock_rental do
    creator_id { nil }
    renter_id { nil }
  end

  factory :upcoming_rental, parent: :mock_rental do
    start_time { (Time.current + 1.day).to_s }
    end_time { (Time.current + 5.days).to_s }
  end

  factory :past_rental, parent: :mock_rental do
    rental_status { 'dropped_off' }
  end

  factory :far_future_rental, parent: :mock_rental do
    start_time { (Time.current + 8.days).to_s }
    end_time { (Time.current + 9.days).to_s }
  end

  factory :ongoing_rental, parent: :mock_rental do
    rental_status { 'picked_up' }
  end
end
