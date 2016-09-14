# frozen_string_literal: true
FactoryGirl.define do
  factory :rental do
    association :user
    association :department
    association :item_type, name: 'TEST_ITEM_TYPE'
    association :item, name: 'TEST_ITEM'
    start_time Time.current
    end_time (Time.current + 1.day)
  end

  factory :invalid_rental, parent: :rental do
    association :user
    association :department
    association :item_type
    association :item
    start_time nil
    end_time (Time.current + 1.day)
  end

  factory :new_rental, parent: :rental do
    user_id nil
    department_id nil
    item_type_id { create(:item_type).id }
    item_id { create(:item).id }
    start_time Time.current
    end_time (Time.current + 1.day)
  end

  factory :mock_rental, parent: :rental do
    association :user
    department_id 0
    association :item_type
    association :item
    sequence :reservation_id
    start_time Time.current
    end_time (Time.current + 1.day)
  end

  factory :upcoming_rental, parent: :rental do
    start_time (Time.current + 1.day).to_s
    end_time (Time.current + 5.days).to_s
  end

  factory :past_rental, parent: :rental do
    rental_status 'checked_in'
  end

  factory :far_future_rental, parent: :rental do
    start_time (Time.current + 8.days).to_s
    end_time (Time.current + 9.days).to_s
  end

  factory :ongoing_rental, parent: :rental do
    rental_status 'checked_out'
  end
end
