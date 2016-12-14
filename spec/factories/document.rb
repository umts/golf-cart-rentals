# frozen_string_literal: true
include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :document do
    uploaded_file {fixture_file_upload('spec/fixtures/file.png', 'image/png')}
  end
end
