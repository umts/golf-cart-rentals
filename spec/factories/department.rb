# frozen_string_literal: true
FactoryBot.define do
  factory :department do
    sequence(:name) { |n| "Group #{n}" }
  end

  factory :invalid_department, parent: :department do
    name {nil}
  end
end
