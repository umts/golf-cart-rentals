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
        Timecop.travel Time.current + 1.day
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
    # the start times and end times here are configured to be overlapping for the conflict and non overlapping for the future rental
    let(:shared_item) { create(:item) }
    let(:hold) { create(:hold, item: shared_item, start_time: 1.day.from_now, end_time: 10.days.from_now) }
    let(:conflicting_rental) do
      create(:rental, start_time: 2.days.from_now, end_time: 4.days.from_now,
                      rentals_items: [build(:rentals_item, item: shared_item)])
    end
    let(:future_rental) do
      create(:rental, start_time: 40.days.from_now, end_time: 42.days.from_now,
                      rentals_items: [build(:rentals_item, item: shared_item)])
    end

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
      hold = create :hold, start_time: 1.day.from_now, end_time: 3.days.from_now

      # conflicting rental starts in range but ends out side of it
      create(:rental, start_time: 2.days.from_now, end_time: 4.days.from_now, rentals_items: [build(:rentals_item, item: hold.item)])
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

    it 'should not create a new rental when the rental is on a different item' do
      create :mock_rental
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

    it 'should send an email when there is no suitable replacement rental' do
      conflicting_rental
      # wont create a replacement rental
      allow(Inventory).to receive(:create_reservation).and_raise(AggressiveInventory::Errors::InventoryExceptions::ReservationNotAvailable)
      expect do
        hold.handle_conflicting_rentals
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      # that matching text is pulled right from the body of the email that should be sent
      expect(ActionMailer::Base.deliveries.last.body).to match(/Unfortunately, there is no other cart available for replacement/)
    end
  end

  context 'conflicting_ongoing_rental' do
    it 'identifies a conflicting ongoing rental' do
      rental = create :mock_rental, start_time: Time.now, end_time: 4.days.from_now
      rental.pickup
      hold = create :hold, item: rental.items.first, start_time: 1.day.from_now
      expect(hold.conflicting_ongoing_rental).to eq(rental)
    end

    it 'doesnt care if it isnt picked up' do
      rental = create :mock_rental, start_time: Time.now, end_time: 4.days.from_now
      hold = create :hold, item: rental.items.first, start_time: 1.day.from_now
      expect(hold.conflicting_ongoing_rental).to be nil
    end

    it 'doesnt return rentals outside of hold range' do
      rental = create :mock_rental, start_time: Time.now, end_time: 4.days.from_now
      rental.pickup
      hold = create :hold, item: rental.items.first, start_time: 5.days.from_now, end_time: 6.days.from_now
      expect(hold.conflicting_ongoing_rental).to be nil
    end
  end
end
