# frozen_string_literal: true
FactoryBot.define do
  factory :hold do
    hold_reason { 'TEST_HOLD_REASON' }
    association :item
    association :item_type
    active { true }
    start_time { Time.current + 1.day }
    end_time { Time.current + 2.days }
  end

  factory :invalid_date_time_hold, parent: :hold do
    end_time { Time.current - 1.day }
  end
end
