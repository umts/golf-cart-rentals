FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    description 'Description'
  end
end
