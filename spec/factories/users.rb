FactoryGirl.define do
  factory :user do |f|
    f.first_name 'John'
    f.last_name 'Doe'
    f.email 'jdoe@test.com'
    f.phone 1_234_567_890
    sequence(:spire_id ) 
  end
end
