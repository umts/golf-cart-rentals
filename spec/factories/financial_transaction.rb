FactoryGirl.define do
  factory :financial_transaction do
    rental
    amount 100
    adjustment 0
    note_field "Property of Factory Girl"
    created_at DateTime.now
    updated_at DateTime.now

    trait :with_transactable_incidental do
      association :transactable, factory: :incidental_type
    end

    trait :with_transactable_fee do
      association :transactable, factory: :fee_schedule
    end

    factory :incidental_type_transaction do
      with_transactable_incidental
    end

    factory :fee_schedule_transaction do
      with_transactable_fee
    end
  end
end

