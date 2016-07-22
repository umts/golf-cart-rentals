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
      polymorphism_trans = rent.financial_transaction

      expect(transaction).to be_valid
      expect(polymorphism_trans).to be_valid

      expect(rent).to eq(transaction.rental)
      expect(transaction).to eq(polymorphism_trans)
      expect(rent).to eq(polymorphism_trans.rental)

      expect(transaction.amount).to eq(((rent.end_time.to_date - rent.start_time.to_date).to_i*rent.item_type.fee_per_day)+rent.item_type.base_fee)
    end
  end

  describe "creating successive financial transactions" do
    before(:each) do
      @item_type = create :item_type, name: 'TEST_ITEM_TYPE'
    end

    it 'creates financial transaction after creating an incurred incidental' do
      rental = create :rental, item_type: @item_type
      rental_trans = rental.financial_transaction
      incidental = create :incurred_incidental, rental: rental
      incidental_trans = incidental.financial_transaction

      expect(incidental_trans).to be_valid
      expect(incidental).to eq(incidental_trans.transactable)
      expect(rental).to eq(incidental_trans.rental)

      expect(incidental_trans.amount).to eq(incidental.incidental_type.base+(incidental.times_modified*incidental.incidental_type.modifier_amount))
    end
  end
end
