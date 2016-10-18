# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name 'Doe'
    email 'jdoe@test.com'
    phone 1_234_567_890
    sequence(:spire_id) { |n| (10000000+n).to_s }
    association :department
    #    active true
  end

  factory :admin_user, parent: :user do
    groups { [Group.find_by(name: 'admin') || create(:admin_group)] }
  end

  factory :invalid_user, parent: :user do
    phone nil
  end
end
