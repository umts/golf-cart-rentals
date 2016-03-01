FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    description 'Description'
  end

  factory :group_with_users_and_permissions, parent: :group do
    user_ids { [create(:user), create(:user)] }
    permission_ids { [create(:permission), create(:permission)] }
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
