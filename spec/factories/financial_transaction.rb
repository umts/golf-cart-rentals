FactoryGirl.define do
  factory :financial_transaction do
    note_field "Property of Factory Girl"
    created_at DateTime.now
    updated_at DateTime.now

    trait :with_rental do
      rental
    end

    trait :with_incidental do
      association :transactable, factory: :incidental_type
    end

    trait :with_fee do
      association :transactable, factory: :fee_schedule
    end

    factory :incidental_type_transaction do
      with_incidental
    end

    factory :fee_schedule_transaction do
      with_fee
    end
  end
end

