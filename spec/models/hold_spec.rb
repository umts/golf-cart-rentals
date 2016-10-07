require 'rails_helper'

RSpec.describe Hold, type: :model do
  describe 'model validates params' do
    it 'correctly builds with valid params' do
      expect(build(:hold)).to be_valid
    end
    it 'does not build without a hold reason' do
      expect(build(:hold, hold_reason: nil)).not_to be_valid
    end
    it 'does not build without an item' do
      expect(build(:hold, item: nil)).not_to be_valid
    end
    it 'does not build without an item type ' do
      expect(build(:hold, item_type: nil)).not_to be_valid
    end
    it 'does not build without a start time' do
      expect(build(:hold, start_time: nil)).not_to be_valid
    end
    it 'does not build without an end time' do
      expect(build(:hold, end_time: nil)).not_to be_valid
    end
    it 'does not allow end time to be earlier than start time' do
      expect(build(:invalid_date_time_hold)).not_to be_valid
    end
  end
end
