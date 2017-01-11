# frozen_string_literal: true
require 'rails_helper'
describe PaymentTrackingController do
  let(:unpaid_rental) { create :mock_rental } # unpaid by default
  let(:paid_rental) do
    rental_paid = create :mock_rental

    # get amount from the transaction created by rental
    amount = FinancialTransaction.find_by(rental: rental_paid, transactable: rental_paid).amount

    # pay for rental
    create :financial_transaction, :with_payment, amount: amount, rental: rental_paid
    # now rental_paid has no balance due

    rental_paid
  end


  describe 'get #index' do
    it 'only returns upaid rentals' do
      unpaid_rental
      paid_rental
      get :index
      expect(assigns[:rentals]).to contain_exactly unpaid_rental
    end
  end

  describe 'post #send_invoice' do
    context 'sends and email' do
      # will send invoice even if there is no balance due
      it 'for a paid rental' do
        expect do
          post :send_invoice, params: { rental_id: paid_rental.id }
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'for an unpaid rental' do
        expect do
          post :send_invoice, params: { rental_id: unpaid_rental.id }
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
