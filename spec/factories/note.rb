FactoryGirl.define do
  factory :note do
    association :noteable, factory: :incurred_incidental
    sequence(:note) { |i| "Note #{i}" }
  end
end
