# frozen_string_literal: true
FactoryGirl.define do
  factory :note do
    sequence(:note) { |i| "Note #{i}" }
  end
end
