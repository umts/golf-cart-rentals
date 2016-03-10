FactoryGirl.define do
  factory :permission do
    controller 'Controller'
    sequence(:action) { |n| "Action #{n}" }
  end
end
