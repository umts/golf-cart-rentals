require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    create(:contact).should be_valid
  end

  it "is invalid without a firstname"
  it "is invalid without a lastname"
  it "is invalid without an email"
  it "is invalid without a phone"
  it "is invalid without a spire_id"

  it "returns a contact's full name as a string"
end
