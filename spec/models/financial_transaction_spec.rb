require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do
  it 'creates a valid financial transaction after creating a rental' do
    #binding.pry
    rental = create(:rental)
    modified_transaction = build(:financial_transaction, rental_id: rental.id)
    unmodified_transaction = build(:financial_transaction)

    expect(modified_transaction).to be_valid
    expect(unmodified_transaction).to be_valid

    expect(modified_transaction.rental).to eq(rental)
    expect(unmodified_transaction.rental).to be_valid

    #expect(rental.financial_transactions.include? f1.rental).to eq(true)
    #expect(f1).to belong_to(:rental)
  end

  it 'creates a valid financial transaction after creating an incurred incidental' do
    #binding.pry

    incidental = create(:incidental_type_transaction)
    unmodified_transaction = build(:incidental_type_transaction)
    modified_transaction =

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
