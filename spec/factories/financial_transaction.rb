# frozen_string_literal: true
FactoryGirl.define do
  factory :financial_transaction do |f|
    f.note_field 'Property of Factory Girl'
    f.created_at DateTime.now
    f.updated_at DateTime.now
    f.initial_amount 1
    rental

    trait :with_rental do
      after(:build) { |f| f.transactable = f.rental }
    end

    trait :with_payment do
      association :transactable, factory: :payment
    end

    trait :with_incidental do
      association :transactable, factory: :incurred_incidental
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
