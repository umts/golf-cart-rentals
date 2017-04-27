# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do
  describe 'testing initial financial transaction params' do
    it 'creates a valid financial transaction from a rental' do
      expect do
        expect(build(:financial_transaction, :with_rental)).to be_valid
      end.to change { FinancialTransaction.count }.by(1)
    end

    it 'does not create a financial transaction from an invalid rental' do
      expect { create :invalid_rental }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'does not create a financial transaction without first creating a rental' do
      expect { create :financial_transaction, rental: nil }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'creates a financial transaction via post hook from creating a Rental' do
      rent = create :mock_rental
      transaction = FinancialTransaction.first
      polymorphism_trans = rent.financial_transaction

      expect(rent).to eq(transaction.rental)
      expect(transaction).to eq(polymorphism_trans)
      expect(rent).to eq(polymorphism_trans.rental)

      base_fee = rent.item_type.base_fee
      daily_fee = rent.item_type.fee_per_day * rent.duration

      expect(transaction.amount).to eq(base_fee + daily_fee)
    end

    it 'is invalid without an amount' do
      expect(build(:financial_transaction, :with_rental, amount: nil)).not_to be_valid
    end

    it 'defaults to 0 when amount is not specified' do
      fc = build(:financial_transaction, :with_rental, amount: 1)
      expect(fc.amount).to eq(1)
    end
  end
end
