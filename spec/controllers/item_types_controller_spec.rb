# frozen_string_literal: true
require 'rails_helper'

describe ItemTypesController do
  let!(:item_type) { create(:item_type) }
  let!(:item_type2) { create(:item_type) }

  describe 'GET #index' do
    it 'populates an array of item_types' do
      get :index
      expect(assigns[:item_types]).to eq([item_type, item_type2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested item_type to @item_type' do
      get :show, params: { id: item_type }
      expect(assigns[:item_type]).to eq(item_type)
    end
    it 'renders the :show template' do
      get :show, params: { id: item_type }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested item_type to @item_type' do
      get :edit, params: { id: item_type }
      expect(assigns[:item_type]).to eq(item_type)
    end
    it 'renders the :edit template' do
      get :edit, params: { id: item_type }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the item_type in the database' do
        new_fee = item_type.base_fee + 10
        post :update, params: { id: item_type, item_type: { base_fee: new_fee } }
        item_type.reload
        expect(item_type.base_fee).to eq(new_fee)
      end
      it 'redirects to the item_type page' do
        new_fee = item_type.base_fee + 10
        post :update, params: { id: item_type, item_type: { base_fee: new_fee } }
        expect(response).to redirect_to item_type
      end
    end

    context 'with invalid attributes' do
      it 'does not save the item_type in the database' do
        old_fee = item_type.base_fee
        post :update, params: { id: item_type, item_type: attributes_for(:invalid_item_type) }
        item_type.reload
        expect(item_type.base_fee).to eq(old_fee)
      end
      it 're-renders the :edit template' do
        post :update, params: { id: item_type, item_type: attributes_for(:invalid_item_type) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #new_item_type' do
    it 'renders the :new_item_type view' do
      get :new_item_type
      expect(response).to render_template :new_item_type
    end
  end

  describe 'POST #create_item_type' do
    context 'with valid attributes' do
      it 'creates an item with valid params' do
        post :create_item_type, params: { item_type: :item_type }
        expect(item_type).to be_valid
        expect(ItemType.find(item_type.id)).to eq(item_type)
      end

      it 'creates an item_type in the database and populates a flash message' do
        expect do
          allow(Inventory).to receive(:create_item_type).and_return(true)
          allow(Inventory).to receive(:create_item_type).and_return([create(:item_type)])
          post :create_item_type, params: { name: item_type.name, base_fee: item_type.base_fee, fee_per_day: item_type.fee_per_day }
          expect(flash[:success]).to be_present
          expect(flash[:success]).to eq('Item Type Successfully Created.')
        end.to change { ItemType.count }.by(1)
      end
    end

    context 'create item_type in api fails' do
      it 'redirects to new_item_types_path' do
        allow(Inventory).to receive(:create_item_type).and_raise('boom')
        post :create_item_type, params: { name: item_type.name, base_fee: item_type.base_fee, fee_per_day: item_type.fee_per_day }
        expect(response).to redirect_to new_item_types_path
      end

      it 'populates a danger flash message' do
        allow(Inventory).to receive(:create_item_type).and_raise('boom')
        post :create_item_type, params: { name: item_type.name, base_fee: item_type.base_fee, fee_per_day: item_type.fee_per_day }
        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eq('That Item Type Already Exists.')
      end
    end
  end

  describe 'GET #refresh_item_types' do
    context 'called independent of #create_item_type with no error' do
      it 'populates a flash success message' do
        allow(Inventory).to receive(:item_types).and_return([create(:item_type)])
        get :refresh_item_types
        expect(flash[:success]).to be_present
        expect(flash[:success]).to eq('Successfully Updated Item Types.')
      end
    end

    context 'called indepedent of #create_item_type with error' do
      it 'populates a flash danger message' do
        allow(Inventory).to receive(:item_types).and_raise('boom')
        get :refresh_item_types
        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eq('Failed to Refresh Item Types From API. #<RuntimeError: boom>')
      end
    end

    it 'redirects to item_types_path' do
      allow(Inventory).to receive(:item_types).and_return([create(:item_type)])
      get :refresh_item_types
      expect(response).to redirect_to item_types_path
    end
  end
end
