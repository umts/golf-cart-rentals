# frozen_string_literal: true
FactoryGirl.define do
  factory :note do
    association :noteable, factory: :incurred_incidental
    note 'Test Note'
  end
end
