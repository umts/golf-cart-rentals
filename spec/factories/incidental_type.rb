# frozen_string_literal: true
FactoryGirl.define do
  factory :incidental_type do
    sequence(:name) { |n| "name #{n}" }
    description 'description'
    base 1
    damage_tracked false
  end

  factory :invalid_type, parent: :incidental_type do
    name nil
  end
end
