# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FinancialTransactionsController, type: :controller do
  let(:ft_transact_rental) do
    (build :financial_transaction, :with_rental).attributes.symbolize_keys
  end

  let(:financial_transaction) do
    (build :financial_transaction).attributes.symbolize_keys
  end

  let(:ft_transact_incidental) do
    (build :financial_transaction, :with_incidental).attributes.symbolize_keys
  end

  describe 'GET #index' do
    it 'assigns all financial_transactions as @financial_transactions' do
      financial_transaction = create(:financial_transaction, :with_rental) # this actually creates two, one for the association and one for this
      get :index
      expect(assigns(:financial_transactions)).to eq(financial_transaction.rental.financial_transactions)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested financial_transaction as @financial_transaction' do
      financial_transaction = create :financial_transaction, :with_rental
      get :show, params: { id: financial_transaction.to_param }
      expect(assigns(:financial_transaction)).to eq(financial_transaction)
    end
  end

  describe 'GET #new' do
    it 'properly creates @financial_transaction for a rental based FinancialTransaction' do
      rental = create :rental
      get :new, params: { rental_id: rental.id, transactable_type: Rental.name, transactable_id: rental.id }
      expect(assigns(:financial_transaction)).to be_a_new(FinancialTransaction)
      expect(assigns(:financial_transaction).rental).to eq(rental)
      expect(assigns(:financial_transaction).transactable_id).to eq(rental.id)
      expect(assigns(:financial_transaction).transactable_type).to eq(Rental.name)
    end

    it 'properly creates @financial_transaction for a IncurredIncidental based FinancialTransaction' do
      rental = create :rental
      ii = create :incurred_incidental
      get :new, params: { rental_id: rental.id, transactable_type: IncurredIncidental.name, transactable_id: ii.id }
      expect(assigns(:financial_transaction)).to be_a_new(FinancialTransaction)
      expect(assigns(:financial_transaction).rental).to eq(rental)
      expect(assigns(:financial_transaction).transactable_id).to eq(ii.id)
      expect(assigns(:financial_transaction).transactable_type).to eq(IncurredIncidental.name)
    end

    it 'properly handles an invalid rental reference' do
      rental = create :rental
      get :new, params: { rental_id: 0, transactable_type: Rental.name, transactable_id: rental.id }
      expect(response.code).to eq('404')
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested financial_transaction as @financial_transaction' do
      financial_transaction = create :financial_transaction, :with_rental
      get :edit, params: { id: financial_transaction.to_param }
      expect(assigns(:financial_transaction)).to eq(financial_transaction)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new rental based FinancialTransaction' do
        attributes = ft_transact_rental # ft_transact_rental has to create one for its rental as well
        expect do
          post :create, params: { financial_transaction: attributes }
        end.to change(FinancialTransaction, :count).by(1)
        expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
        expect(assigns(:financial_transaction)).to be_persisted
        expect(assigns(:financial_transaction).transactable_id).to eq(attributes[:rental_id])
        expect(assigns(:financial_transaction).amount).to eq attributes[:amount]
        expect(assigns(:financial_transaction).transactable_type).to eq(Rental.name)
        expect(response).to redirect_to(action: :invoice, controller: :rentals, id: attributes[:rental_id])
      end

      it 'creates a payment based FinancialTransaction' do # specialized logic, params are passed in root and payment is created in this controller
        attributes = financial_transaction.merge(transactable_type: Payment.name) # creates a rental at the same time
        payment = { payment_type: Payment.payment_types.keys.first, contact_name: 'jill', contact_email: 'jill@gmail.com', contact_phone: '8608675309' }
        expect do
          post :create, params: { financial_transaction: attributes }.merge(payment)
        end.to(change(FinancialTransaction, :count).by(1)) && change(Payment, :count).by(1)
        expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
        expect(assigns(:financial_transaction)).to be_persisted
        expect(assigns(:financial_transaction).transactable_id).to eq(Payment.last.id)
        expect(assigns(:financial_transaction).transactable_type).to eq(Payment.name)
        expect(response).to redirect_to(action: :invoice, controller: :rentals, id: attributes[:rental_id])
      end

      it 'creates a new IncurredIncidental based FinancialTransaction' do
        attributes = ft_transact_incidental # ft_transact_incidental has to create one for its rental as well
        expect do
          post :create, params: { financial_transaction: attributes }
        end.to change(FinancialTransaction, :count).by(1)
        expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
        expect(assigns(:financial_transaction)).to be_persisted
        expect(assigns(:financial_transaction).transactable_id).to eq(attributes[:transactable_id])
        expect(assigns(:financial_transaction).transactable_type).to eq(IncurredIncidental.name)
        expect(response).to redirect_to(action: :invoice, controller: :rentals, id: attributes[:rental_id])
      end
    end

    context 'with invalid params' do
      it "re-renders the 'new' template given invalid params" do
        post :create, params: { financial_transaction: { 'notnil' => 'for real' } }
        expect(response).to render_template('new')
      end

      it 'will not create a payment based financial transaction without the proper params' do
        attributes = financial_transaction.merge(transactable_type: Payment.name) # creates a rental at the same time
        payment = { payment_type: Payment.payment_types.keys.first } # missing payment attributes
        expect do
          post :create, params: { financial_transaction: attributes }.merge(payment)
        end.not_to(change(FinancialTransaction, :count)) && change(Payment, :count)
        expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
        expect(assigns(:financial_transaction)).not_to be_persisted
        expect(assigns(:financial_transaction).transactable_type).to eq(Payment.name)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    it 'cannot find a route' do
      ft = create :financial_transaction
      expect do
        put :update, params: { id: ft.to_param }
      end.to raise_error AbstractController::ActionNotFound
    end
  end

  describe 'DELETE #destroy' do
    it 'cannot find a route' do
      ft = create :financial_transaction
      expect do
        delete :destroy, params: { id: ft.to_param }
      end.to raise_error AbstractController::ActionNotFound
    end
  end
end
