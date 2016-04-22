require 'rails_helper'

RSpec.describe Rental do
  it 'has a valid factory' do
    expect(build(:rental)).to be_valid
  end
  it 'is invalid without a reservation_id' do
    expect(build(:rental, reservation_id: nil)).not_to be_valid
  end
  it 'is invalid without a user_id' do
    expect(build(:rental, user_id: nil)).not_to be_valid
  end
  it 'is invalid without an item_type_id' do
    expect(build(:rental, item_type_id: nil)).not_to be_valid
  end
  it 'is invalid without a start_date' do
    expect(build(:rental, start_date: nil)).not_to be_valid
  end
  it 'is invalid without a end_date' do
    expect(build(:rental, end_date: nil)).not_to be_valid
  end
  it 'is invalid with a start_date before today' do
    expect(build(:rental, start_date: Time.zone.yesterday)).not_to be_valid
  end
  it 'is invalid with an end_date before the start_date' do
    expect(build(:rental, start_date: Time.zone.tomorrow, end_date: Time.zone.today)).not_to be_valid
  end
  it 'does not allow duplicate reservation_id' do
    rental = create(:rental)
    expect(build(:rental, reservation_id: rental.reservation_id)).not_to be_valid
  end

  pending '#create_reservation'
  pending '#delete_reservation'

  describe '#mostly_valid?' do
    it 'returns true if the item is valid except for a missing reservation_id' do
      expect(build(:rental, reservation_id: nil).mostly_valid?).to be true
    end
    it 'returns false if the item is in_valid except for a missing reservation_id' do
      expect(build(:invalid_rental, reservation_id: nil).mostly_valid?).to be false
    end
  end

  describe '#dates' do
    it 'returns a string with dates' do
      rental = create(:rental)
      expect(rental.dates).to be_a(String)
    end
  end

  describe 'rental_status' do
    let(:rental) { create :rental }

    it 'is reserved upon creation' do
      expect(rental).to be_reserved
    end

    it 'is canceled after cancel' do
      rental.cancel!
      expect(rental).to be_canceled
    end

    it 'is checked_out after pickup' do
      rental.pickup!
      expect(rental.checked_out_at).not_to be_nil
      expect(rental).to be_checked_out
    end

    it 'is checked_in after return' do
      rental.pickup
      rental.return!
      expect(rental.checked_in_at).not_to be_nil
      expect(rental).to be_checked_in
    end

    it 'is inspected after approve' do
      rental.pickup
      rental.return
      rental.approve!
      expect(rental).to be_inspected
    end

    it 'is available after process' do
      rental.pickup
      rental.return
      rental.approve
      rental.process!
      expect(rental).to be_available
    end
  end
end
