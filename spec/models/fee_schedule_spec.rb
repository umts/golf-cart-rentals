require 'rails_helper'

RSpec.describe FeeSchedule, type: :model do
  it 'has valid factory' do
    expect(build(:fee_schedule)).to be_valid
  end
  it 'is invalid without base_amount' do
    expect(build(:fee_schedule, base_amount: nil)).not_to be_valid
  end
  it 'is invalid without amount_per_day' do
    expect(build(:fee_schedule, amount_per_day: nil)).not_to be_valid
  end
  it 'is invalid without item_type_id' do
    expect(build(:fee_schedule, item_type_id: nil)).not_to be_valid
  end
  it 'is invalid with a negative base_amount' do
    expect(build(:fee_schedule, base_amount: -1)).not_to be_valid
  end
  it 'is invalid with a negative amount_per_day' do
    expect(build(:fee_schedule, amount_per_day: -1)).not_to be_valid
  end
end
