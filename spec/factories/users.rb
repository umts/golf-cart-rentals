FactoryGirl.define do
  factory :user do |f|
    f.firstname "John"
    f.lastname "Doe"
    f.email "jdoe@test.com"
    f.phone 1234567890
    f.spire_id "1234567890"
  end
end