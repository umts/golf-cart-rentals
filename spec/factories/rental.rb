FactoryGirl.define do
  factory :rental do
    association :user
    association :department
    association :item_type, name: 'TEST_ITEM_TYPE'
    association :item, name: "TEST_ITEM"
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
end
