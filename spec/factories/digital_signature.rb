# frozen_string_literal: true
FactoryBot.define do
  factory :digital_signature do
    rental
    image { 'fake image' }
    intent { :pickup }
    author { :csr }
  end
end
