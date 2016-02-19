require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    create(:user).should be_valid
  end
  it "is invalid without a first_name" do
    build(:user, first_name: nil).should_not be_valid
  end
  it "is invalid without a last_name" do
    build(:user, last_name: nil).should_not be_valid
  end
  it "is invalid without an email" do
    build(:user, email: nil).should_not be_valid
  end
  it "is invalid without a phone" do
    build(:user, phone: nil).should_not be_valid
  end
  it "is invalid without a spire_id" do
    build(:user, spire_id: nil).should_not be_valid
  end
  
  describe 'full_name' do
    let(:user) { create :user }
    it 'returns first name and last name with a space in between' do
      expect(user.full_name).to eql "#{user.first_name} #{user.last_name}"
    end
  end
end
