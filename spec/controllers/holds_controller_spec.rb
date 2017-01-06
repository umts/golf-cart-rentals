# frozen_string_literal: true
require 'rails_helper'

describe HoldsController do
  let!(:hold) { create :hold }

  let(:item) { create(:item, name: 'TEST_ITEM') }
  let(:item_type) { create(:item_type, name: 'TEST_ITEM_TYPE') }

  describe 'GET #show' do
    it 'assigns the requested hold to @hold' do
      get :show, params: { id: hold }
      expect(assigns[:hold]).to eq(hold)
    end

    it 'renders the :show template' do
      get :show, params: { id: hold }
      expect(response).to render_template :show
    end
  end

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

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new hold in the database' do
        expect do
          put :create, params: { hold: attributes_for(:hold, item_id: Item.first) }
        end.to change(Hold, :count).by(1)
      end

      it 'redirects to the hold show page' do
        post :create, params: { hold: attributes_for(:hold, item_id: Item.first) }
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
        post :create, params: { hold: attributes_for(:invalid_date_time_hold, item_id: Item.first) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested hold to @hold' do
      get :edit, params: { id: hold }
      expect(assigns[:hold]).to eq(hold)
    end

    it 'renders the :edit view' do
      get :edit, params: { id: hold }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    before(:each) do
      @hold = create(:hold)
    end

    it 'change hold with valid data' do
      new_hold_reason = 'NEW_TEST_HOLD_REASON'
      new_start_time = @hold.start_time + 1.day
      new_end_time = @hold.end_time + 2.days
      post :update, params: { id: @hold.id, hold: { hold_reason: new_hold_reason, start_time: new_start_time, end_time: new_end_time, item_id: Item.first } }
      @hold.reload
      expect(@hold.hold_reason).to eq(new_hold_reason)
      expect(@hold.start_time).to eq(new_start_time)
      expect(@hold.end_time).to eq(new_end_time)
    end

    it 'no change for hold with non valid data' do
      old_start_time = @hold.start_time
      old_end_time = @hold.end_time
      post :update, params: { id: @hold.id, hold: { start_time: @hold.start_time + 5.days, end_time: @hold.end_time + 1.day, item_id: Item.first } }
      @hold.reload
      expect(@hold.start_time).to eq(old_start_time)
      expect(@hold.end_time).to eq(old_end_time)
    end

    it 'redirects to :show page if updated Successfully' do
      post :update, params: { id: @hold.id, hold: { start_time: @hold.start_time + 5.days, end_time: @hold.end_time + 10.days, item_id: Item.first } }
      expect(response).to redirect_to Hold.last
    end

    it 'redirects to :edit template if update fails' do
      post :update, params: { id: @hold.id, hold: { start_time: @hold.start_time + 5.days, end_time: @hold.end_time + 1.day, item_id: Item.first } }
      expect(response).to render_template :edit
    end
  end
end
