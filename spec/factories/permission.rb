# frozen_string_literal: true
FactoryBot.define do
  factory :permission do
    controller 'Controller'
    sequence(:action) { |n| "Action #{n}" }
  end
end
