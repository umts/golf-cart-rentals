# frozen_string_literal: true
FactoryGirl.define do
  factory :payment do
    payment_type 0
    contact_name 'billy'
    contact_email 'billy@bill.net'
    contact_phone '8606176147'
  end
end
