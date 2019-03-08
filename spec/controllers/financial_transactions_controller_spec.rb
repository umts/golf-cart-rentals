# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FinancialTransactionsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all financial_transactions as @financial_transactions' do
      financial_transaction = create(:financial_transaction, :with_rental) # this actually creates two, one for the association and one for this
      get :index
      expect(assigns(:financial_transactions)).to eq(financial_transaction.rental.financial_transactions)
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

  describe 'POST #create' do
    let(:rental) { create :rental }
    before :each do
      attributes = attributes_for(:financial_transaction)
        .merge(rental_id: rental.id)
      @params = {
        financial_transaction: attributes
      }
    end
    let :submit do
      post :create, params: @params
    end
    context 'with valid params' do
      it 'creates a new rental based FinancialTransaction' do
        @params[:financial_transaction][:transactable_type] = Rental.name
        @params[:financial_transaction][:transactable_id] = rental.id
        expect{ submit }.to change(FinancialTransaction, :count).by(1)
        expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
        expect(assigns(:financial_transaction)).to be_persisted
        expect(assigns(:financial_transaction).transactable_id).to eq(rental.id)
        expect(assigns(:financial_transaction).amount)
          .to eq(@params[:financial_transaction][:amount])
        expect(assigns(:financial_transaction).transactable_type).to eq(Rental.name)
        expect(response).to redirect_to(
          action: :invoice, controller: :rentals, id: rental.id
        )
      end
      context 'payment based' do
        it 'creates a payment based FinancialTransaction' do
          @params[:financial_transaction][:transactable_type] = Payment.name
          payment = { 
            payment_type: Payment.payment_types.keys.first,
            contact_name: 'jill',
            contact_email: 'jill@gmail.com',
            contact_phone: '8608675309' 
          }
          @params.merge! payment
          expect{ submit }.to change{ FinancialTransaction.count }.by(1) && 
            change{ Payment.count }.by(1)
          expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
          expect(assigns(:financial_transaction)).to be_persisted
          expect(assigns(:financial_transaction).transactable_id).to eq(Payment.last.id)
          expect(assigns(:financial_transaction).transactable_type).to eq(Payment.name)
          expect(response).to redirect_to(
            action: :invoice, controller: :rentals, id: rental.id
          )
        end

        it 'also takes a reference field' do
          @params[:financial_transaction][:transactable_type] = Payment.name
          payment = { 
            payment_type: Payment.payment_types.keys.first,
            contact_name: 'jill',
            contact_email: 'jill@gmail.com',
            contact_phone: '8608675309',
            reference: 'asfadlj' 
          }
          @params.merge! payment
          expect{ submit }.to(change(FinancialTransaction, :count).by(1)) && change(Payment, :count).by(1)
          expect(assigns(:financial_transaction).transactable.reference).to eq 'asfadlj'
          expect(response).to redirect_to(
            action: :invoice, controller: :rentals, id: rental.id
          )
        end
      end

      it 'creates a new IncurredIncidental based FinancialTransaction' do
        @params[:financial_transaction][:transactable_type] = IncurredIncidental.name
        expect{ submit }.to change(FinancialTransaction, :count).by(1)
        expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
        expect(assigns(:financial_transaction)).to be_persisted
        expect(assigns(:financial_transaction).transactable_id)
          .to eq(@params[:transactable_id])
        expect(assigns(:financial_transaction).transactable_type).to eq(IncurredIncidental.name)
        expect(response).to redirect_to(
          action: :invoice, controller: :rentals, id: rental.id
        )
      end
    end

    context 'with invalid params' do
      it "re-renders the 'new' template given invalid params" do
        post :create, params: { financial_transaction: { 'notnil' => 'for real' } }
        expect(response).to render_template('new')
      end

      it 'will not create a payment based financial transaction without the proper params' do
        @params[:financial_transaction][:transactable_type] = Payment.name
        # missing payment attributes
        payment = { payment_type: Payment.payment_types.keys.first } 
        @params.merge! payment
        expect { submit }.not_to(change(FinancialTransaction, :count)) && change(Payment, :count)
        expect(assigns(:financial_transaction)).to be_a(FinancialTransaction)
        expect(assigns(:financial_transaction)).not_to be_persisted
        expect(assigns(:financial_transaction).transactable_type).to eq(Payment.name)
        expect(response).to render_template('new')
      end
    end
  end
end
