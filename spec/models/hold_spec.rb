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

    context 'time sensitive' do
      after :each do
        Timecop.return # always return
      end

      it 'moves datetimes to end_of_day and beginning_of_day' do
        Timecop.freeze
        hold = create :hold, start_time: Date.current.end_of_day, end_time: Date.tomorrow.beginning_of_day
        expect(hold.start_time).to eq(Date.current.beginning_of_day)
        # for some reasone it was loosint accuracy if i compared equality
        expect(hold.end_time).to be > Date.tomorrow.beginning_of_day
      end

      it 'allows the item to be updated even if start time is after current date if the item is saved' do
        hold = create(:hold, start_time: Time.current, end_time: Time.current + 4.days)
        Timecop.travel Time.current+1.day
        hold.reload
        expect(hold.start_time).to be < Time.current
        hold.update(active: false)
        expect(hold).to be_valid
      end
    end

    it 'does not allow end time to be earlier than start time' do
      expect(build(:invalid_date_time_hold)).not_to be_valid
    end
  end

  describe 'handle_conflicting_rentals' do
    let(:hold) { create(:hold) }
    let(:conflicting_rental) { create(:hold_conflicting_rental) }
    let(:future_rental) { create(:far_future_rental) }

    it 'should cancel a conflicting rental' do
      conflicting_rental
      hold.handle_conflicting_rentals
      expect(conflicting_rental.reload).to be_canceled
    end

    it 'should not affect a future rental' do
      future_rental
      expect do
        hold.handle_conflicting_rentals
      end.not_to change(future_rental, :rental_status)
    end

    it 'should create a new rental when there is a conflicting rental' do
      conflicting_rental
      expect do
        hold.handle_conflicting_rentals
      end.to change(Rental, :count).by(1)
    end

    it 'should handle when a rental falls within the hold but not exactly on it' do
      hold = create :hold, start_time: 1.days.from_now, end_time: 3.days.from_now

      # conflicting rental starts in range but ends out side of it
      create(:hold_conflicting_rental, start_time: 2.days.from_now, end_time: 4.days.from_now)
      expect do
        hold.handle_conflicting_rentals
      end.to change(Rental, :count).by(1)
    end

    it 'should not create a new rental when there is not a conflicting rental' do
      future_rental
      expect do
        hold.handle_conflicting_rentals
      end.to change(Rental, :count).by(0)
    end

    it 'should send an email when there is a conflicting rental' do
      conflicting_rental
      expect do
        hold.handle_conflicting_rentals
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end
end
