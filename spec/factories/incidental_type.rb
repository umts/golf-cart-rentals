# frozen_string_literal: true
FactoryGirl.define do
  factory :incidental_type do
    sequence(:name) { |n| "name #{n}" }
    description 'description'
    base 1
    modifier_amount 1
    modifier_description '1'
  end

  factory :invalid_type, parent: :incidental_type do
    name nil
  end
end
