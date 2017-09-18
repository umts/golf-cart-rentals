# frozen_string_literal: true
FactoryGirl.define do
  factory :rental do
    association :creator, factory: :user
    renter { creator } # set renter equal to creator by default
    start_time Time.current
    end_time (Time.current + 1.day)

    after(:build) do |rental|
      # add the rentals_items, no reservation id
      if rental.rentals_items.empty?
        rental.rentals_items << build(:rentals_item, reservation_id: nil)
      end
    end
  end

  factory :mock_rental, parent: :rental do
    before(:create) do |rental| # reservations are automatically created after create, doing this before will prevent that
      # give a reservation id to all of the items
      rental.reservations= (1..(rental.items.count)).to_a
    end
  end

  factory :invalid_rental, parent: :mock_rental do
    start_time nil
  end

  factory :new_rental, parent: :mock_rental do
    creator_id nil
    renter_id nil
  end

  factory :upcoming_rental, parent: :mock_rental do
    start_time (Time.current + 1.day).to_s
    end_time (Time.current + 5.days).to_s
  end

  factory :hold_conflicting_rental, parent: :mock_rental do
    start_time Time.current + 1.day
    end_time Time.current + 2.days
  end

  factory :past_rental, parent: :mock_rental do
    rental_status 'dropped_off'
  end

  factory :far_future_rental, parent: :mock_rental do
    start_time (Time.current + 8.days).to_s
    end_time (Time.current + 9.days).to_s
  end

  factory :ongoing_rental, parent: :mock_rental do
    rental_status 'picked_up'
  end
end
