FactoryGirl.define do
  factory :incidental_type do
    sequence(:name) { |n| "name #{n}" }
    sequence(:description) { |n| "description #{n}" }
    base 1
    modifier_amount 1
    modifier_description "1"
  end
end
