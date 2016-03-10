FactoryGirl.define do
  factory :incurred_incidental do
    times_modified 1
    notes "note"
    association :incidental_type
  end
end
