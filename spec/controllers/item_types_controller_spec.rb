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
      get :show, id: item_type
      expect(assigns[:item_type]).to eq(item_type)
    end
    it 'renders the :show template' do
      get :show, id: item_type
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested item_type to @item_type' do
      get :edit, id: item_type
      expect(assigns[:item_type]).to eq(item_type)
    end
    it 'renders the :edit template' do
      get :edit, id: item_type
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the item_type in the database' do
        new_fee = item_type.base_fee + 10
        post :update, id: item_type, item_type: { base_fee: new_fee }
        item_type.reload
        expect(item_type.base_fee).to eq(new_fee)
      end
      it 'redirects to the item_type page' do
        new_fee = item_type.base_fee + 10
        post :update, id: item_type, item_type: { base_fee: new_fee }
        expect(response).to redirect_to item_type
      end
    end

    context 'with invalid attributes' do
      it 'does not save the item_type in the database' do
        old_fee = item_type.base_fee
        post :update, id: item_type, item_type: attributes_for(:invalid_item_type)
        item_type.reload
        expect(item_type.base_fee).to eq(old_fee)
      end
      it 're-renders the :edit template' do
        post :update, id: item_type, item_type: attributes_for(:invalid_item_type)
        expect(response).to render_template :edit
      end
    end
  end
end
