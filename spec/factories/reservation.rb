# frozen_string_literal: true
FactoryGirl.define do
  factory :reservation do
    association :item_type, name: 'TEST_ITEM_TYPE'
    association :item, name: 'TEST_ITEM'
    reservation_type 'TEST_RESERVATION_TYPE'
    start_time Time.current
    end_time (Time.current + 1.day)
  end

  factory :invalid_date_time_reservation, parent: :reservation do
    association :item_type, name: 'TEST_ITEM_TYPE'
    association :item, name: 'TEST_ITEM'
    reservation_type 'TEST_RESERVATION_TYPE'
    start_time Time.current
    end_time (Time.current - 1.day)
  end
end
