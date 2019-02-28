# frozen_string_literal: true
FactoryBot.define do
  factory :financial_transaction do
    note_field { 'Property of Factory Girl' }
    amount { 1 }
    association :rental

    trait :with_rental do
      after(:build) { |o| o.transactable = o.rental }
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
