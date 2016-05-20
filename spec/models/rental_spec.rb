require 'rails_helper'

RSpec.describe Rental do
  before do
    @item_type = create(:item_type, name: 'TEST_ITEM_TYPE')
  end
  describe '#validations' do
    it 'has a valid factory' do
      expect(build(:rental)).to be_valid
    end
    it 'has a can build with alias date designations' do
      expect(build(:rental, start_date: Time.current, end_date: (Time.current + 1.day))).to be_valid
    end
    it 'is invalid without a user_id' do
      expect(build(:rental, user_id: nil)).not_to be_valid
    end
    it 'is invalid without an item_type_id' do
      expect(build(:rental, item_type_id: nil)).not_to be_valid
    end
    it 'is invalid without a start_time' do
      expect(build(:rental, start_time: nil)).not_to be_valid
    end
    it 'is invalid without a end_time' do
      expect(build(:rental, end_time: nil)).not_to be_valid
    end
    it 'is invalid with a start_time before today' do
      expect(build(:rental, start_time: Time.zone.yesterday)).not_to be_valid
    end
    it 'is invalid with an end_time before the start_time' do
      expect(build(:rental, start_time: Time.zone.tomorrow, end_time: Time.zone.today)).not_to be_valid
    end
    context 'creating two rentals' do
      it 'does not allow duplicate reservation_id' do
        rental = create(:rental, item_type: @item_type)
        expect(build(:rental, reservation_id: rental.reservation_id)).not_to be_valid
      end
      after :each do # cleanup
        Rental.last.destroy
      end
    end
  end

  describe '#create_rental' do
    before do
      @rent = create :rental, item_type: @item_type
    end

    it 'creates a rental with valid parameters' do
      expect(@rent).to be_valid
      expect(Rental.find(@rent.id)).to eq(@rent)
    end

    it 'creates a reservation with the external api' do
      response = nil
      expect { response = Inventory.reservation(@rent.reservation_id) }.not_to raise_error
      expect(response[:uuid]).to eq(@rent.reservation_id)
    end

    after do
      @rent.destroy
    end
  end

  describe '#reservation_creation_errors' do
    it 'fails to create an item for an item_type that does not exist' do
      item_type = create :item_type, name: 'i do not exist'
      expect { create :rental, item_type: item_type }.to raise_error ActiveRecord::RecordNotSaved
    end
  end

  describe '#delete_rental' do
    before :each do
      @rent = create :rental, item_type: @item_type
    end

    it 'deletes a rental properly' do
      expect do
        @rent.destroy
      end.to change { Rental.count }.by(-1)
    end

    it 'deletes associated reservation on the external api' do
      uuid = @rent.reservation_id
      expect do
        @rent.destroy
      end.to change { Rental.count }.by(-1)
      expect { Inventory.reservation(uuid) }.to raise_error ReservationNotFound
    end
  end

  describe '#mostly_valid?' do
    it 'returns true if the item is valid except for a missing reservation_id' do
      expect(build(:rental, reservation_id: nil).mostly_valid?).to be true
    end
    it 'returns false if the item is in_valid except for a missing reservation_id' do
      expect(build(:invalid_rental, reservation_id: nil).mostly_valid?).to be false
    end
  end

  describe '#times' do
    before :each do
      @rental = create(:rental, item_type: @item_type)
    end

    after :each do
      @rental.destroy
    end

    it 'returns a string with times' do
      expect(@rental.times).to be_a(String)
      expect(@rental.dates).to be_a(String)
    end
  end

  describe 'rental_status' do
    before :each do
      @rental = create :rental, item_type: @item_type
    end

    after :each do
      @rental.destroy
    end

    it 'is reserved upon creation' do
      expect(@rental).to be_reserved
    end

    it 'is canceled after cancel' do
      @rental.cancel!
      expect(@rental).to be_canceled
    end

    it 'is checked_out after pickup' do
      @rental.pickup!
      expect(@rental.checked_out_at).not_to be_nil
      expect(@rental).to be_checked_out
    end

    it 'is checked_in after return' do
      @rental.pickup
      @rental.return!
      expect(@rental.checked_in_at).not_to be_nil
      expect(@rental).to be_checked_in
    end

    it 'is inspected after approve' do
      @rental.pickup
      @rental.return
      @rental.approve!
      expect(@rental).to be_inspected
    end

    it 'is available after process' do
      @rental.pickup
      @rental.return
      @rental.approve
      @rental.process!
      expect(@rental).to be_available
    end
  end
end
