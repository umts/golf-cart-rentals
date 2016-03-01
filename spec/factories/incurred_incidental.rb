FactoryGirl.define do
  factory :incurred_incidental do
    times_modified 1
    sequence(:notes) { |n| "note #{n}" }
    association :incidental_type
  end
end
