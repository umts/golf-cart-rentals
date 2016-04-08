FactoryGirl.define do
  factory :document do
    sequence(:filename) { |n| "file#{n}.txt" }
  end
end
