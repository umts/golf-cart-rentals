# frozen_string_literal: true
FactoryGirl.define do
  factory :incurred_incidental do
    association :rental, factory: :mock_rental
    association :incidental_type

    after(:build) do |incidental|
      incidental.notes = FactoryGirl.build_list(:note, 1)
    end

    trait :with_documents do
      after(:build) do |incidental|
        incidental.documents = FactoryGirl.build_list(:document, 2)
      end
    end
  end

  factory :invalid_incidental, parent: :incurred_incidental do
    rental_id nil
    financial_transaction_attributes initial_amount: 5
  end
end
