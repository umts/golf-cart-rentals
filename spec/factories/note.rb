# frozen_string_literal: true
FactoryBot.define do
  factory :note do
    sequence(:note) { |i| "Note #{i}" }
  end
end
