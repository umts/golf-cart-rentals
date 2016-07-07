FactoryGirl.define do
  factory :incurred_incidental do
    times_modified 1
    association :incidental_type
    association :rental, factory: :mock_rental
  end
end
