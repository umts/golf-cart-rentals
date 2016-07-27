require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

  let!(:item) { create(:item) }
  let!(:item2) { create(:item) }
  let!(:item_type) { create(:item_type) }
  let!(:item_type2) { create(:item_type) }

  describe 'GET #index' do
    it 'populates an array of items' do
      get :index
      expect(assigns[:items]).to eq([item, item2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested item to @item' do
      get :show, id: item
      expect(assigns[:item]).to eq(item)
    end
    it 'renders the :show template' do
      get :show, id: item
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested item to @item' do
      get :edit, id: item
      expect(assigns[:item]).to eq(item)
    end
    it 'renders the :edit template' do
      get :edit, id: item
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the item in the database' do
        new_name = "TestItem"
        post :update, id: item, item: { name: new_name }
        item.reload
        expect(item.name).to eq(new_name)
      end
      it 'redirects to the item page' do
        new_name = "TestItem"
        post :update, id: item, item: { name: new_name }
        expect(response).to redirect_to item
      end
    end

    context 'with invalid attributes' do
      it 'does not save the item in the database' do
        old_name = item.name
        post :update, id: item, item: attributes_for(:invalid_item)
        item.reload
        expect(item.name).to eq(old_name)
      end
      it 're-renders the :edit template' do
        post :update, id: item, item: attributes_for(:invalid_item)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #new_item' do
    it 'it populates an array of item_types' do
      get :new_item
      expect(assigns[:item_types]).to eq([item_type, item_type2])
    end
    it 'renders the :new_item view' do
      get :new_item
      expect(response).to render_template :new_item
    end
  end

  describe 'POST #create_item' do
    context 'with valid attributes' do
      it 'creates an item with valid params' do
        post :create_item, item: :item
        expect(item).to be_valid
        expect(Item.find(item.id)).to eq(item)
      end

      it 'creates an item in the database and populates flash message' do
        expect do
          allow(Inventory).to receive(:create_item).and_return(true)
          allow(Inventory).to receive(:items_by_type).and_return([create(:item)])
          post :create_item, name: item.name, type: item_type.name
          expect(flash[:success]).to be_present
          expect(flash[:success]).to eq('Your cart has been successfully created. Items have been updated.')
        end.to change { Item.count }.by(1)
      end
    end

    context 'with no name' do
      it 'populates a danger flash message' do
        post :create_item, name: '', type: item_type.name
        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eq('Enter a name for the cart')
      end
    end

    context 'create item in api fails' do
      it 'redirects to new_item_items_path' do
        allow(Inventory).to receive(:create_item).and_raise("boom")
        post :create_item, name: item.name, type:item_type.name
        expect(response).to redirect_to new_item_items_path
      end

      it 'populates a danger flash message' do
        allow(Inventory).to receive(:create_item).and_raise("boom")
        post :create_item, name: item.name, type: item_type.name
        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eq('Failed to create cart in API. #<RuntimeError: boom>')
      end
    end
  end

  describe 'GET #refresh_items' do
    context 'called independent of #create_item with no error' do
      it 'populates a flash success message' do
        allow(Inventory).to receive(:items_by_type).and_return([create(:item)])
        get :refresh_items
        expect(flash[:success]).to be_present
        expect(flash[:success]).to eq('Items have been updated.')
      end
    end

    context 'called independent of #create_item with error' do
      it 'populates a flash danger message' do
        allow(Inventory).to receive(:items_by_type).and_raise("boom")
        get :refresh_items
        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eq('Failed to refresh items from api. #<RuntimeError: boom>')
      end
    end

    it 'redirects to items_path' do
      allow(Inventory).to receive(:items_by_type).and_return([create(:item)])
      get :refresh_items
      expect(response).to redirect_to items_path
    end
  end

  describe 'DELETE #destroy' do
    it 'locates an item record' do
      delete :destroy, id: item.id
      item.reload
      expect(item.deleted_at).not_to eq(nil)
    end
    it 'renders the items index' do
      delete :destroy, id: item.id
      expect(response).to redirect_to items_path
    end
  end

end
