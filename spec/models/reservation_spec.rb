# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '#create_reservation' do
    it 'be able to create reservation with valid date time' do
      reservation = create :reservation
      expect(reservation).to be_valid
      expect(Reservation.find(reservation.id)).to eq(reservation)
    end

    it 'fail to create reservation with invalid date time' do
      invalid_reservation = build :invalid_date_time_reservation
      expect(invalid_reservation.save).to be false
    end
  end

  describe '#delete_reservation' do
    before(:each) do
      @reservation = create(:reservation)
    end
    it 'able to properly delete a reservation' do
      expect do
        @reservation.destroy
      end.to change { Reservation.count }.by(-1)
    end
  end
end
