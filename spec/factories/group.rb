FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    description 'Description'
  end

  factory :invalid_group, parent: :group do
    name nil
  end
end
