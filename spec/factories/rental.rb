# frozen_string_literal: true
FactoryBot.define do
  factory :rental do
    association :creator, factory: :user
    renter { creator } # set renter equal to creator by default
    start_time { Time.current }
    end_time { (Time.current + 1.day) }

    after(:build) do |rental|
      # add the rentals_items, no reservation id
      if rental.rentals_items.empty?
        rental.rentals_items << build(:rentals_item, reservation_id: nil)
      end
    end
  end

  factory :rental_without_items, parent: :rental do
    after(:build) do |rental|
      rental.rentals_items = []
    end
  end

  factory :mock_rental, parent: :rental do
    # reservations are automatically created after create, doing this before will prevent that
    before(:create) do |rental|
      # give a reservation id to all of the items
      rental.rentals_items.each do |r|
        r.reservation_id = SecureRandom.uuid
      end
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
