# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Rental do
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
        rental = create :mock_rental
        expect(build(:rental, reservation_id: rental.reservation_id)).not_to be_valid
      end
    end
  end

  describe '#create_rental' do
    before(:each) do
      @rent = create :mock_rental
    end

    it 'creates a rental with valid parameters' do
      expect(@rent).to be_valid
      expect(Rental.find(@rent.id)).to eq(@rent)
    end
  end

  describe '#delete_rental' do
    before :each do
      @rent = create :mock_rental
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
      @rental = create :mock_rental
    end

    it 'returns a string with times' do
      expect(@rental.times).to be_a(String)
      expect(@rental.dates).to be_a(String)
    end
  end

  describe '#sum_amount' do
    before :each do
      @rental = create :mock_rental
    end

    it 'return the sum of all @rental\'s financial transation amounts' do
      sum_amount = FinancialTransaction.where(rental: @rental).map(&:amount).inject(:+)
      expect(@rental.sum_amount).to eq(sum_amount)
    end
  end

  describe 'rental_status' do
    before :each do
      @rental = create :mock_rental
    end

    it 'is reserved upon creation' do
      expect(@rental).to be_reserved
    end

    it 'is canceled after cancel' do
      @rental.cancel!
      expect(@rental).to be_canceled
    end

    it 'is picked_up after pickup' do
      @rental.pickup!
      expect(@rental.picked_up_at).not_to be_nil
      expect(@rental).to be_picked_up
    end

    it 'is dropped_off after return' do
      @rental.pickup
      @rental.drop_off!
      expect(@rental.dropped_off_at).not_to be_nil
      expect(@rental).to be_dropped_off
    end

    it 'is canceled after being processed as a no show' do
      @rental.process_no_show!
      expect(@rental).to be_canceled
    end

    it 'is inspected after approve' do
      @rental.pickup
      @rental.drop_off
      @rental.approve!
      expect(@rental).to be_inspected
    end

    it 'is available after process' do
      @rental.pickup
      @rental.drop_off
      @rental.approve
      @rental.process!
      expect(@rental).to be_available
    end
  end

  describe '#create_financial_transaction' do
    it '.create_financial_transaction callback is triggered on create' do
      rental = build(:rental)
      # Critical section.
      Mutex.new.synchronize do
        expect(rental).to receive(:create_financial_transaction)
        rental.save
      end
    end
    it 'creates a finacial transaction based on the item_type' do
      rental = build(:rental)
      expect(rental.financial_transaction).to be(nil)
      rental.save
      expect(rental.financial_transaction).to be_an_instance_of(FinancialTransaction)
    end
  end

  describe '#event_status_color' do
    before :each do
      @rental = create :mock_rental
    end
    it 'returns #0092ff when reserved' do
      expect(@rental.event_status_color).to eq('#0092ff')
    end
    it 'returns #f7ff76 when picked_up' do
      @rental.rental_status = :picked_up
      expect(@rental.event_status_color).to eq('#f7ff76')
    end
    it 'returns #09ff00 when dropped_off' do
      @rental.rental_status = :dropped_off
      expect(@rental.event_status_color).to eq('#09ff00')
    end
    it 'returns #ff0000 when cancelled' do
      @rental.rental_status = :canceled
      expect(@rental.event_status_color).to eq('#ff0000')
    end
    it 'returns #000000 when approved' do
      @rental.rental_status = :inspected
      expect(@rental.event_status_color).to eq('#000000')
    end
    it 'returns #000000 when processed' do
      @rental.rental_status = :available
      expect(@rental.event_status_color).to eq('#000000')
    end
  end

  describe '#basic_info' do
    it 'returns basic info of new rental' do
      @item_type = create :item_type
      @rental = create :mock_rental, item_type: @item_type
      expect(@rental.basic_info).to eq("#{@item_type.name}:(#{@rental.start_time.to_date} -> #{@rental.end_time.to_date})")
    end
  end

  describe '#event_name' do
    it 'returns event name of new rental' do
      @item_type = create :item_type
      @rental = create :mock_rental, item_type: @item_type
      expect(@rental.event_name).to eq("#{@item_type.name}(#{@item_type.id}) - Rental ID: #{@rental.id}")
    end
  end

  it "doesn't allow a zero day rental" do
    time = Time.current
    rent = build(:mock_rental, start_time: time, end_time: time)
    expect(rent).not_to be_valid
  end
  it 'creates a 1 day financial transaction with value: 100' do
    rent = create :mock_rental, end_time: (Time.current + 1.second)
    expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([100])
  end
  it 'creates a 2 day financial transaction with value: 110' do
    rent = create :mock_rental
    expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([110])
  end
  it 'creates a 3 day financial transaction with value: 120' do
    rent = create :mock_rental, end_time: (Time.current + 2.days)
    expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([120])
  end
  it 'creates a 6 day financial transaction with value: 160' do
    rent = create :mock_rental, end_time: (Time.current + 6.days)
    expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([160])
  end
  it 'creates a 7 day financial transaction with value: 160 (1 day free)' do
    rent = create :mock_rental, end_time: (Time.current + 7.days)
    expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([160])
  end
  it 'creates a 14 day financial transaction with value: 300 (2 days free)' do
    rent = create :mock_rental, end_time: (Time.current + 14.days)
    expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([220])
  end
  it 'creates a 2 day financial transaction with different fees with value: 220' do
    rent = create :mock_rental, item_type: create(:item_type, name: 'Test 220', base_fee: 200, fee_per_day: 20)
    expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([220])
  end

  describe '#delete_reservation' do
    context 'error thrown' do
      it 'logs the error and returns false' do
        r = build(:rental)
        r.create_reservation
        allow(Inventory).to receive(:delete_reservation).and_raise(InventoryExceptions::AuthError)
        expect(r.delete_reservation).to be false
      end
    end
  end

  describe '#create_reservation' do
    context 'error thrown' do
      it 'logs error and returns false for a series of errors' do
        r = build(:rental)
        allow(Inventory).to receive(:create_reservation).and_raise(InventoryExceptions::InventoryError)
        expect(r.create_reservation).to be false
        r = build(:rental)
        allow(Inventory).to receive(:create_reservation).and_raise(InventoryExceptions::ReservationError)
        expect(r.create_reservation).to be false
        r = build(:rental)
        allow(Inventory).to receive(:create_reservation).and_raise(InventoryExceptions::AuthError)
        expect(r.create_reservation).to be false
      end
    end
  end

  describe '#cost' do
    it 'gets cost' do
      expect(Rental.cost(Date.today, Date.tomorrow, create(:item_type))).not_to be_nil
    end
  end
end
