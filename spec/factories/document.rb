FactoryGirl.define do
  factory :document do
    sequence :filename do |n| "file#{n}.txt" end
  end
end
