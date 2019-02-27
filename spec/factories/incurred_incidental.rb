# frozen_string_literal: true
FactoryBot.define do
  factory :incurred_incidental do
    association :rental
    association :incidental_type

    after(:build) do |incidental|
      incidental.notes = FactoryBot.build_list(:note, 1)
      # in reality it will be one of the rentals_items from the rental,
      # always the first is good enough
      if incidental.rental.present?
        incidental.item = incidental.rental.rentals_items.first.item
      end
    end

    trait :with_documents do
      after(:build) do |incidental|
        incidental.documents = FactoryBot.build_list(:document, 2)
      end
    end
  end

  factory :invalid_incidental, parent: :incurred_incidental do
    rental_id { nil }
  end
end
