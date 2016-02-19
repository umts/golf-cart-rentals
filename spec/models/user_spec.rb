require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build :user).to be_valid
  end
  it 'is invalid without a first_name' do
    expect(build :user, first_name: nil).not_to be_valid
  end
  it 'is invalid without a last_name' do
    expect(build :user, last_name: nil).not_to be_valid
  end
  it 'is invalid without an email' do
    expect(build :user, email: nil).not_to be_valid
  end
  it 'is invalid without a phone' do
    expect(build :user, phone: nil).not_to be_valid
  end
  it 'is invalid without a spire_id' do
    expect(build :user, spire_id: nil).not_to be_valid
  end
  describe 'full_name' do
    let(:user) { create :user }
    it 'returns first name and last name with a space in between' do
      expect(user.full_name).to eql "#{user.first_name} #{user.last_name}"
    end
  end
end
