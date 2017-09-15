# frozen_string_literal: true
FactoryGirl.define do
  factory :rental do
    association :creator, factory: :user
    renter { creator } # set renter equal to creator by default
    start_time Time.current
    end_time (Time.current + 1.day)

    # add the rentals_items, no reservation id
    it = create(:item_type, name: 'TEST_ITEM_TYPE')
    items { [create(:item, name: 'TEST_ITEM', item_type: it)] }
    item_types { [it] }
  end

  factory :mock_rental, parent: :rental do
    # give a reservation id
    reservation_ids { (1..(items.count)).to_a }
  end

  factory :invalid_rental, parent: :mock_rental do
    start_time nil
  end

  factory :new_rental, parent: :mock_rental do
    creator_id nil
    renter_id nil
    item_type_id { create(:item_type).id }
    item_id { create(:item).id }
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
