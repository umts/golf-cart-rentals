FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name 'Doe'
    email 'jdoe@test.com'
    phone 1_234_567_890
    sequence(:spire_id)
  end
end
