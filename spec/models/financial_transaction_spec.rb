# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FinancialTransaction do
  describe 'testing initial financial transaction params' do
    it 'creates a valid financial transaction from a rental' do
      expect do
        expect(build(:financial_transaction, :with_rental)).to be_valid
      end
    end

    it 'does not create a financial transaction from an invalid rental' do
      expect { create :rental, start_time: nil }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'does not create a financial transaction without first creating a rental' do
      expect { create :financial_transaction, rental: nil }.to raise_error ActiveRecord::RecordInvalid
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
