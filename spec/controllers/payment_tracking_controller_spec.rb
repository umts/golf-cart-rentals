# frozen_string_literal: true
require 'rails_helper'
describe PaymentTrackingController do
  include ActiveJob::TestHelper
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

  before :each do
    current_user super_user
  end

  describe 'get #index' do
    it 'only returns unpaid rentals' do
      unpaid_rental
      paid_rental
      get :index, params: { balance_gteq: 1 }
      expect(assigns[:rentals]).to contain_exactly unpaid_rental
    end

    it 'default returns all rentals' do
      unpaid_rental
      paid_rental
      get :index
      expect(assigns[:rentals]).to contain_exactly unpaid_rental, paid_rental
    end
  end

  describe 'post #send_invoice' do
    context 'sends an email' do
      # will send invoice even if there is no balance due
      it 'for a paid rental' do
        paid_rental
        # this block ensures all async ActiveJob's will be performed synchronously so they can be tested
        perform_enqueued_jobs do
          expect do
            post :send_invoice, params: { rental_id: paid_rental.id }
          end.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
        expect(ActionMailer::Base.deliveries.last.subject).to eq("Invoice for Rental #{paid_rental.basic_info}")
      end

      it 'for an unpaid rental' do
        unpaid_rental
        # this block ensures all async ActiveJob's will be performed synchronously so they can be tested
        perform_enqueued_jobs do
          expect do
            post :send_invoice, params: { rental_id: unpaid_rental.id }
          end.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
        expect(ActionMailer::Base.deliveries.last.subject).to eq("Invoice for Rental #{unpaid_rental.basic_info}")
      end
    end

    context 'doesnt send invoice' do
      it 'doesnt have permission' do
        current_user # set to new unprivileged user
        unpaid_rental

        perform_enqueued_jobs do
          expect do
            post :send_invoice, params: { rental_id: unpaid_rental.id }
          end.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
      end
    end
  end

  describe 'post #send_many_invoices' do
    it 'sends multiple invoices by email' do
      unpaid_rental
      paid_rental
      # this block ensures all async ActiveJob's will be performed synchronously so they can be tested
      perform_enqueued_jobs do
        expect do
          post :send_many_invoices, params: { rentals: [unpaid_rental, paid_rental] }
        end.to change { ActionMailer::Base.deliveries.count }.by(2)
      end
      expect(response).to be_ok
      expect(JSON.parse(response.body)['errors']).to be_empty
    end

    it 'handles errors' do
      # this block ensures all async ActiveJob's will be performed synchronously so they can be tested
      perform_enqueued_jobs do
        expect do
          post :send_many_invoices, params: { rentals: [-1, -2] } # these id's couldnt possibly exist
        end.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
      expect(response.code).to eq '207'
      expect(JSON.parse(response.body)['errors']).to contain_exactly('-1', '-2')
    end

    context 'doesnt send invoice' do
      it 'doesnt have permission' do
        current_user # set to new unprivileged user

        # creates rental now so they dont get emails sent inside the perform_enqueued_jobs block
        unpaid_rental
        paid_rental

        perform_enqueued_jobs do
          expect do
            post :send_many_invoices, params: { rentals: [unpaid_rental.id, paid_rental.id] } # these id's couldnt possibly exist
          end.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
        expect(response.code).to eq '207'
        expect(JSON.parse(response.body)['errors']).to contain_exactly unpaid_rental.id.to_s, paid_rental.id.to_s
      end
    end
  end
end
