FactoryGirl.define do
  factory :incurred_incidental do
    association :rental, factory: :mock_rental
    association :incidental_type
    times_modified 1
  end

  factory :invalid_incidental, parent: :incurred_incidental do
    times_modified nil
  end
end
