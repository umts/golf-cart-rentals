# frozen_string_literal: true
FactoryGirl.define do
  factory :rental do
    association :creator, factory: :user
    association :renter, factory: :user
    association :department
    association :item_type, name: 'TEST_ITEM_TYPE'
    association :item, name: 'TEST_ITEM'
    start_time Time.current
    end_time (Time.current + 1.day)
  end

  factory :invalid_rental, parent: :mock_rental do
    association :creator, factory: :user
    association :renter, factory: :user
    association :department
    association :item_type
    association :item
    start_time nil
    end_time (Time.current + 1.day)
  end

  factory :new_rental, parent: :mock_rental do
    creator_id nil
    renter_id nil
    department_id nil
    item_type_id { create(:item_type).id }
    item_id { create(:item).id }
    start_time Time.current
    end_time (Time.current + 1.day)
  end

  factory :mock_rental, parent: :rental do
    association :creator, factory: :user
    association :renter, factory: :user
    association :department
    association :item_type
    association :item
    sequence :reservation_id
    start_time Time.current
    end_time (Time.current + 1.day)
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
