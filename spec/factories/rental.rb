FactoryGirl.define do
  factory :rental do
    association :user
    association :department
    association :item_type, name: 'TEST_ITEM_TYPE'
    start_time Time.current.to_s
    end_time (Time.current + 1.day).to_s
  end

  factory :invalid_rental, parent: :rental do
    start_time nil
  end

  factory :new_rental, parent: :rental do
    user_id nil
    department_id nil
    item_type_id { create(:item_type).id }
    start_time Time.current.to_s
    end_time (Time.current + 1.day).to_s
  end

  factory :mock_rental, parent: :rental do
    association :user
    department_id 0
    association :item_type
    sequence :reservation_id
    start_time Time.current.to_s
    end_time (Time.current + 1.day).to_s
  end
end
