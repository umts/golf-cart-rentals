FactoryGirl.define do
  factory :incurred_incidental do
    association :rental, factory: :mock_rental
    association :incidental_type
    adjustment_amount 1
  end

  factory :invalid_incidental, parent: :incurred_incidental do
    adjustment_amount nil
  end
end
