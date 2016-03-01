FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    description 'Description'
  end

  factory :admin_group, parent: :group do
    name 'Admin'
    description 'Admin group'
    permissions { Permission.all }
  end

  factory :invalid_group, parent: :group do
    name nil
  end
end
