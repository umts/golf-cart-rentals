# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FinancialTransactionsController, type: :controller do
  let(:ft_transact_rental) do
    attributes_for :financial_transaction, :with_rental
  end

  let(:ft_transact_incidental) do
    attributes_for :financial_transaction, :with_incidental
  end

  let(:ft_transact_fee) do
    attributes_for :financial_transaction, :with_fee
  end

  let(:invalid_attributes) do
    {}
  end

  let(:valid_session) do
    {}
  end

  describe 'GET #index' do
    it 'assigns all financial_transactions as @financial_transactions' do
      financial_transaction = create(:financial_transaction) # this actually creates two, one for the association and one for this
      get :index, {}, valid_session
      expect(assigns(:financial_transactions)).to eq(financial_transaction.rental.financial_transactions)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested financial_transaction as @financial_transaction' do
      financial_transaction = create :financial_transaction
      get :show, params: { id: financial_transaction.to_param }
      expect(assigns(:financial_transaction)).to eq(financial_transaction)
    end
  end

  describe 'GET #new' do
    it 'properly creates @financial_transaction for a rental based FinancialTransaction' do
      rental = create :rental
      get :new, params: {rental_id: rental.id, transactable_type: Rental.name, transactable_id: rental.id }
      expect(assigns(:financial_transaction)).to be_a_new(FinancialTransaction)
      expect(assigns(:financial_transaction).rental).to eq(rental)
      expect(assigns(:financial_transaction).transactable_id).to eq(rental.id)
      expect(assigns(:financial_transaction).transactable_type).to eq(Rental.name)
    end

    it 'properly creates @financial_transaction for a IncurredIncidental based FinancialTransaction' do
      rental = create :rental
      ii = create :incurred_incidental
      get :new, params: {rental_id: rental.id, transactable_type: IncurredIncidental.name, transactable_id: ii.id }
      expect(assigns(:financial_transaction)).to be_a_new(FinancialTransaction)
      expect(assigns(:financial_transaction).rental).to eq(rental)
      expect(assigns(:financial_transaction).transactable_id).to eq(ii.id)
      expect(assigns(:financial_transaction).transactable_type).to eq(IncurredIncidental.name)
    end

    it 'properly creates @financial_transaction for a FeeSchedule based FinancialTransaction' do
      skip('fee shedule is not done yet')
      rental = create :rental
      get :new, { rental_id: rental.id, transactable_type: FeeSchedule.name, transactable_id: rental.id }, valid_session
      expect(assigns(:financial_transaction)).to be_a_new(FinancialTransaction)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested financial_transaction as @financial_transaction' do
      financial_transaction = FinancialTransaction.create! valid_attributes
      get :edit, { id: financial_transaction.to_param }, valid_session
      expect(assigns(:financial_transaction)).to eq(financial_transaction)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new FinancialTransaction' do
        expect do
          post :create, { financial_transaction: valid_attributes }, valid_session
        end.to change(FinancialTransaction, :count).by(1)
      end

      it 'assigns a newly created financial_transaction as @financial_transaction' do
        post :create, { financial_transaction: valid_attributes }, valid_session
        expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
        expect(assigns(:financial_transaction)).to be_persisted
      end

      it 'redirects to the created financial_transaction' do
        post :create, { financial_transaction: valid_attributes }, valid_session
        expect(response).to redirect_to(FinancialTransaction.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved financial_transaction as @financial_transaction' do
        post :create, { financial_transaction: invalid_attributes }, valid_session
        expect(assigns(:financial_transaction)).to be_a_new(FinancialTransaction)
      end

      it "re-renders the 'new' template" do
        post :create, { financial_transaction: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested financial_transaction' do
        financial_transaction = FinancialTransaction.create! valid_attributes
        put :update, { id: financial_transaction.to_param, financial_transaction: new_attributes }, valid_session
        financial_transaction.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested financial_transaction as @financial_transaction' do
        financial_transaction = FinancialTransaction.create! valid_attributes
        put :update, { id: financial_transaction.to_param, financial_transaction: valid_attributes }, valid_session
        expect(assigns(:financial_transaction)).to eq(financial_transaction)
      end

      it 'redirects to the financial_transaction' do
        financial_transaction = FinancialTransaction.create! valid_attributes
        put :update, { id: financial_transaction.to_param, financial_transaction: valid_attributes }, valid_session
        expect(response).to redirect_to(financial_transaction)
      end
    end

    context 'with invalid params' do
      it 'assigns the financial_transaction as @financial_transaction' do
        financial_transaction = FinancialTransaction.create! valid_attributes
        put :update, { id: financial_transaction.to_param, financial_transaction: invalid_attributes }, valid_session
        expect(assigns(:financial_transaction)).to eq(financial_transaction)
      end

      it "re-renders the 'edit' template" do
        financial_transaction = FinancialTransaction.create! valid_attributes
        put :update, { id: financial_transaction.to_param, financial_transaction: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'cannot find a route' do
      delete :destroy, { id: financial_transaction.to_param }, valid_session
      expect(response).to render_template('404')
    end
  end
end
