require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do

  describe 'testing initial financial transaction params' do
    it 'creates a valid financial transaction from a rental' do
      binding.pry
      @item_type = create :item_type, name: 'TEST_ITEM_TYPE'
      valid_rental = create :valid_rental, item_type: @item_type

      valid_transaction = build :financial_transaction, rental_id: valid_rental.id

      expect(valid_transaction).to be_valid
      expect(valid_transaction.rental).to eq(valid_rental)

      #expect(rental.financial_transactions.include? f1.rental).to eq(true)
      #expect(f1).to belong_to(:rental)
    end

    it 'does not create a financial transaction from an invalid rental' do
      invalid_rental = create :invalid_rental
      invalid_transaction = build :financial_transaction, rental_id: invalid_rental.id

      # expect invalid_transaction to raise and error
      expect(invalid_transaction).to_not be_valid
    end

    it 'does not create a financial transaction without first creating a rental' do
      transaction = create :financial_transaction

      # expext some error to be thrown
      expect(transaction.rental).to be_nil?
    end

    it 'creates a financial transaction via post hook from creating a Rental' do
      transaction = create(:valid_rental).financial_transaction

      expect(transaction).to be_valid?
    end
  end

  describe "creating successive financial transactions" do
    before(:each) do
      @item_type = create :item_type, name: 'TEST_ITEM_TYPE'
      valid_rental = create :valid_rental, item_type: @item_type

      valid_transaction = build :financial_transaction, rental_id: valid_rental.id
      rental_trans = rental.transaction
      expect(rental_trans).to be_valid?
    end

    it 'creates a valid financial transaction after creating an incurred incidental' do
      #binding.pry
      incidental = create(:incidental)
      incidental_trans = create(:incidental_type_transaction, incidental)


      expect(incidental_trans).to be_valid?
      expect(incidental_trans.rental).to be_eq(rental) #expect the incidental's rental refers to the same starting rental.
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
