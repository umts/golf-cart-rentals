# frozen_string_literal: true
FactoryBot.define do
  factory :permission do
    controller { 'User' }
    action { 'show' }
  end
end
