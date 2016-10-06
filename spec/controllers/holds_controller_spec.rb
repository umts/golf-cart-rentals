require 'rails_helper'

describe HoldsController do
  let!(:hold) { create :hold }

  let(:item_type) { create(:item_type, name: 'TEST_ITEM_TYPE') }
  let(:item) { create(:item, name: "TEST_ITEM") }

  describe 'GET #index' do
    it 'populates an array of holds' do
      get :index
      expect(assigns[:holds]).to eq([hold])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it 'assigns a new hold to @hold' do
      get :new
      expect(assigns[:hold]).to be_a_new(Hold)
    end

    it 'renders the :new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'renders the :edit view' do
      get :edit, params: { id: hold }
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @hold = create(:hold)
    end

    it 'change hold with valid data' do
      old_start_time = @hold.start_time
      old_end_time = @hold.end_time
      old_hold_reason = @hold.hold_reason
      put :update, params: { id: @hold, hold: { start_time: @hold.start_time.tomorrow, end_time: @hold.end_time.tomorrow, hold_reason: 'TEST_HOLD_TYPE2' } }
      @hold.reload
      expect(@hold.start_time).not_to eq(old_start_time)
      expect(@hold.end_time).not_to eq(old_end_time)
      expect(@hold.hold_reason).not_to eq(old_hold_reason)
    end

    it 'no change for hold with non valid data' do
      new_start_time = @hold.end_time + 10.day
      new_end_time = @hold.start_time - 10.day
      post :update, params: { id: @hold, hold: { start_time: new_start_time, end_time: new_end_time } }
      @hold.reload
      expect(@hold.start_time).not_to eq(new_start_time)
      expect(@hold.end_time).not_to eq(new_end_time)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new hold in the database' do
        expect do
          put :create, params: { hold: attributes_for(:hold, item_type_id: ItemType.first) }
        end.to change(Hold, :count).by(1)
      end
      it 'redirects to the hold show page' do
        post :create, params: { hold: attributes_for(:hold, item_type_id: ItemType.first) }
        expect(response).to redirect_to Hold.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new hold in the database' do
        expect do
          post :create, params: { hold: attributes_for(:invalid_date_time_hold) }
        end.to_not change(Hold, :count)
      end
      it 're-renders the :new template' do
        post :create, params: { hold: attributes_for(:invalid_date_time_hold) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the hold from the database' do
      expect do
        delete :destroy, params: { id: hold.id }
      end.to change(Hold, :count).by(-1)
    end
    it 'redirects to the users index page' do
      delete :destroy, params: { id: hold.id }
      expect(response).to redirect_to holds_url
    end
  end
end
