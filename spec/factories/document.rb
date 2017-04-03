# frozen_string_literal: true
include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :document do
    uploaded_file { fixture_file_upload('spec/fixtures/file.png', 'image/png') }
    desc 'whatever'
    trait :with_invalid_file do
      uploaded_file 'thing'
    end

    trait :with_text_file do
      uploaded_file { fixture_file_upload('spec/fixtures/file.txt', 'text/plain') }
    end
  end
end
