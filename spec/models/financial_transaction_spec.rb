require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do

  describe 'testing initial financial transaction params' do
    before(:each) do
      @item_type = create :item_type, name: 'TEST_ITEM_TYPE'
    end

    it 'creates a valid financial transaction from a rental' do
      valid_rental = create :rental, item_type: @item_type
      valid_transaction = build :financial_transaction, rental_id: valid_rental.id

      expect(valid_transaction).to be_valid
      expect(valid_transaction.rental).to eq(valid_rental)
    end

    it 'does not create a financial transaction from an invalid rental' do
      expect { invalid_rental = create :invalid_rental }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'does not create a financial transaction without first creating a rental' do
      expect { invalid_transaction = create :financial_transaction }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'creates a financial transaction via post hook from creating a Rental' do
      rent = create :rental, item_type: @item_type
      transaction = FinancialTransaction.where(rental_id: rent.id).first

      expect(transaction).to be_valid
      expect(rent).to eq(transaction.rental)
      expect(transaction.amount).to eq((((rent.end_time.to_date - rent.start_time.to_date).to_i-1)*rent.item_type.fee_per_day)+rent.item_type.base_fee)
    end
  end

  describe "creating successive financial transactions" do
    before(:each) do
      @item_type = create :item_type, name: 'TEST_ITEM_TYPE'
      @rental = create :rental, item_type: @item_type
      @rental_trans = FinancialTransaction.where(rental_id: rental.id).first
    end

    it 'checks that the rental transaction is properly allocated' do
      expect(@rental).to eq(@rental_trans.rental)
      expect(@rental_trans.amount).to eq((((@rental.end_time.to_date - @rental.start_time.to_date).to_i-1)*@rental.item_type.fee_per_day)+@rental.item_type.base_fee)
    end

    it 'creates financial transaction after creating an incurred incidental' do
      binding.pry

      incidental = create :incurred_incidental
      type = incident.incidental_type
      incidental_trans = incidental.financial_transaction

      expect(incidental_trans).to be_valid?
      expect(incidental).to eq(incidental_trans.transactable)

      expect(incidental.fee).to eq(type.base + (incident.times_modified * type.modifier_amount))

      expect(incidental_trans.).to be_eq(rental) #expect the incidental's rental refers to the same starting rental.
      expect(incidental_trans.transactable).to eq(incidental)
      expect(incidental_trans).to eq(incidental_trans.transactable)
      financial_transaction = build(:incidental_type_transaction,
                                    rental_id: rental.id,
                                    transactable_id: incidental.id
      )
      expect(financial_transaction.transactable).to eq(incidental)
    end

    it 'creates a valid financial transcation after creating an fee schedule' do
      #binding.pry
      rental = create(:rental)
      fee_schedule = create(:fee_schedule)
      financial_transaction = build(:fee_schedule_transaction,
                                    rental_id: rental.id,
                                    transactable_id: fee_schedule.id
      )
      expect(financial_transaction.transactable).to eq(fee_schedule)
    end
  end
end
