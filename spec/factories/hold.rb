FactoryGirl.define do
  factory :hold do
    hold_reason 'TEST_HOLD_REASON'
    association :item, name: "TEST_ITEM"
    association :item_type, name: 'TEST_ITEM_TYPE'
    start_time Time.current
    end_time (Time.current + 1.day)
  end

  factory :invalid_date_time_hold, parent: :hold do
    hold_reason 'TEST_HOLD_REASON'
    association :item, name: "TEST_ITEM"
    association :item_type, name: 'TEST_ITEM_TYPE'
    start_time Time.current
    end_time (Time.current - 1.day)
  end
end
