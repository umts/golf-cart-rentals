FactoryGirl.define do
  factory :incurred_incidental do
    association :incidental_type
    times_modified 1
  end
end
