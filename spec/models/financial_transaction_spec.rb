require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do
    it 'creates a valid financial transcation after creating a rental' do
      rental = create(:rental)
      f1 = build(:financial_transaction, rental_id: rental.id)
      expect(f1.rental).to eq(rental)
      #expect(rental.financial_transactions.include? f1.rental).to eq(true)
      #expect(f1).to belong_to(:rental)
    end

    it 'creates a valid financial transcation after creating an incurred incidental' do
      binding.pry
      rental = create(:rental)
      incidental = create(:incidental_type)
      financial_transaction = build(:financial_transaction,
                                    rental_id: rental.id,
                                    transactable_type: 'IncidentalType',
                                    transactable_id: incidental.id
                                   )
      expect(financial_transaction.transactable).to eq(incidental)
    end

    it 'creates a valid financial transcation after creating an fee schedule' do
      binding.pry
      rental = create(:rental)
      fee_schedule = create(:fee_schedule)
      financial_transaction = build(:financial_transaction,
                                    rental_id: rental.id,
                                    transactable_type: 'FeeSchedule',
                                    transactable_id: fee_schedule.id
                                   )
      expect(financial_transaction.transactable).to eq(fee_schedule)
    end
end
