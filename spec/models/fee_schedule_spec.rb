require 'rails_helper'

RSpec.describe FeeSchedule, type: :model do
  it 'has valid factory' do
    expect(build(:fee_schedule)).to be_valid
  end

  it 'invalid without base_amount' do
    expect(build(:fee_schedule, base_amount: nil)).not_to be_valid
  end

  it 'invalid without amount_per_day' do
    expect(build(:fee_schedule, amount_per_day: nil)).not_to be_valid
  end
end
