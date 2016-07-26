require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do

  describe 'testing initial financial transaction params' do
    it 'creates a valid financial transaction from a rental' do
      expect do
      expect( build :financial_transaction, :with_rental ).to be_valid
      end.to change { FinancialTransaction.count }.by(1)
    end

    it 'does not create a financial transaction from an invalid rental' do
      expect { create :invalid_rental }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'does not create a financial transaction without first creating a rental' do
      expect { create :financial_transaction }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'creates a financial transaction via post hook from creating a Rental' do
      rent = create :rental
      transaction = FinancialTransaction.first
      polymorphism_trans = rent.financial_transaction

      expect(rent).to eq(transaction.rental)
      expect(transaction).to eq(polymorphism_trans)
      expect(rent).to eq(polymorphism_trans.rental)

      base_fee = rent.item_type.base_fee
      daily_fee = rent.item_type.fee_per_day

      expect(transaction.amount).to eq(base_fee + daily_fee)
    end
  end

  describe "creating successive financial transactions" do
    it 'creates financial transaction after creating an incurred incidental' do
      rental = create :rental
      rental_trans = rental.financial_transaction
      incidental = create :incurred_incidental, rental: rental
      incidental_trans = incidental.financial_transaction

      expect(incidental_trans).to be_valid
      expect(incidental).to eq(incidental_trans.transactable)
      expect(rental).to eq(incidental_trans.rental)

      base = 1
      times_modded = 1
      type_mod = 1
      expect(incidental_trans.amount).to eq(base + (times_modded * type_mod))
    end
  end
end
