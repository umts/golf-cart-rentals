FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name 'Doe'
    email 'jdoe@test.com'
    phone 1_234_567_890
    sequence(:spire_id)
  end

  factory :admin_user, parent: :user do
    groups { [Group.find_by(name: 'Admin') || create(:admin_group)] }
  end

  factory :invalid_user, parent: :user do
    first_name nil
  end
end
