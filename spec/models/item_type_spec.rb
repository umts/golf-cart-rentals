require 'rails_helper'

RSpec.describe ItemType, type: :model do
  it 'has a valid factory' do
    expect(build(:item_type)).to be_valid
  end
  it 'is invalid without a name' do
    expect(build(:item_type, name: nil)).not_to be_valid
  end
  it 'is invalid without a base_fee' do
    expect(build(:item_type, base_fee: nil)).not_to be_valid
  end
  it 'is invalid without a fee_per_day' do
    expect(build(:item_type, fee_per_day: nil)).not_to be_valid
  end
  it 'is invalid without a disclaimer' do
    expect(build(:item_type, disclaimer: '')).not_to be_valid
  end
  it 'is invalid with a negative base_fee' do
    expect(build(:item_type, base_fee: -1)).not_to be_valid
  end
  it 'is invalid with a negative fee_per_day' do
    expect(build(:item_type, fee_per_day: -1)).not_to be_valid
  end
end
