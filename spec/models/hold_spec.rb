# frozen_string_literal: true
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

    it 'does not allow a past start time' do
      expect(build(:hold, start_time: Time.current - 1.day)).not_to be_valid
    end

    it 'does not allow a past end time' do
      expect(build(:hold, end_time: Time.current - 1.day)).not_to be_valid
    end

    it 'does not allow end time to be earlier than start time' do
      expect(build(:invalid_date_time_hold)).not_to be_valid
    end
  end

  describe 'check_conflicting_rentals' do
    let(:hold) { create(:hold) }
    let(:conflicting_rental) { create(:hold_conflicting_rental) }
    let(:future_rental) { create(:far_future_rental) }

    it 'should cancel a conflicting rental' do
      conflicting_rental
      hold.check_conflicting_rentals
      expect(conflicting_rental.reload).to be_canceled
    end

    it 'should not affect a future rental' do
      future_rental
      expect do
        hold.check_conflicting_rentals
      end.not_to change(future_rental, :rental_status)
    end

    it 'should create a new rental when there is a conflicting rental' do
      conflicting_rental
      expect do
        hold.check_conflicting_rentals
      end.to change(Rental, :count).by(1)
    end

    it 'should not create a new rental when there is not a conflicting rental' do
      future_rental
      expect do
        hold.check_conflicting_rentals
      end.to change(Rental, :count).by(0)
    end
  end
end
