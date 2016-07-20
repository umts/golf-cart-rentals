require 'rails_helper'

RSpec.describe Rental do
  before(:each) do
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
    it 'is invalid without a department_id' do
      expect(build(:rental, department_id: nil)).not_to be_valid
    end
    context 'creating two rentals' do
      it 'does not allow duplicate reservation_id' do
        rental = create(:mock_rental, item_type: @item_type)
        expect(build(:rental, reservation_id: rental.reservation_id)).not_to be_valid
      end
    end
  end

  describe '#create_rental' do
    before(:each) do
      @rent = create :mock_rental, item_type: @item_type
    end

    it 'creates a rental with valid parameters' do
      expect(@rent).to be_valid
      expect(Rental.find(@rent.id)).to eq(@rent)
    end
  end

  describe '#delete_rental' do
    before :each do
      @rent = create :mock_rental, item_type: @item_type
      expect_any_instance_of(Rental).to receive(:delete_reservation).and_return(true)
    end

    it 'deletes a rental properly' do
      expect do
        @rent.destroy
      end.to change { Rental.count }.by(-1)
    end
  end

  describe 'check if the rental object is valid or not' do
    it 'returns true if the item is valid except for a missing reservation_id' do
      expect(build(:rental, reservation_id: nil).valid?).to be true
    end
    it 'returns false if the item is in_valid except for a missing reservation_id' do
      expect(build(:invalid_rental, reservation_id: nil).valid?).to be false
    end
  end

  describe '#times' do
    before :each do
      @rental = create(:mock_rental, item_type: @item_type)
    end

    it 'returns a string with times' do
      expect(@rental.times).to be_a(String)
      expect(@rental.dates).to be_a(String)
    end
  end

  describe 'rental_status' do
    before :each do
      @rental = create :mock_rental, item_type: @item_type
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

  describe '#create_financial_transaction' do
    it '.create_financial_transaction callback is triggered on create' do
      rental = build(:rental)
      # Critical section.
      Mutex.new.synchronize{
       expect(rental).to receive(:create_financial_transaction)
       rental.save
     }
    end
   it 'creates a finacial transaction based on the item_type' do
    rental = build(:rental)
    expect(rental.financial_transaction).to be(nil)
    rental.save
    expect(rental.financial_transaction).to be_an_instance_of(FinancialTransaction)
  end
end
end
