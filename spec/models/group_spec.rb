require 'rails_helper'

RSpec.describe Group, type: :model do
  it 'has a valid factory' do
    expect(build :group).to be_valid
  end
  it 'is invalid without a name' do
    expect(build :group, name: nil).not_to be_valid
  end
  it 'is invalid without a description' do
    expect(build :group, description: nil).not_to be_valid
  end
  it "does not allow duplicate names" do
    group = create(:group)
    expect(build :group, name: group.name).not_to be_valid
  end
end
