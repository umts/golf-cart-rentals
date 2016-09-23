require 'rails_helper'

describe ReservationsController do
  let!(:reservation) { create :reservation }

  let(:item_type) { create(:item_type, name: 'TEST_ITEM_TYPE') }
  let(:item) { create(:item, name: "TEST_ITEM") }

  describe 'GET #index' do
    it 'populates an array of reservation' do
      get :index
      expect(assigns[:reservations]).to eq([reservation])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it 'assigns a new reservation to @reservation' do
      get :new
      expect(assigns[:reservation]).to be_a_new(Reservation)
    end

    it 'renders the :new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'renders the :edit view' do
      get :edit, params: { id: reservation }
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @reservation = create(:reservation)
    end

    it 'change reservation with valid data' do
      old_start_time = @reservation.start_time
      old_end_time = @reservation.end_time
      old_reservation_type = @reservation.reservation_type
      put :update, params: { id: @reservation, reservation: { start_time: @reservation.start_time.tomorrow, end_time: @reservation.end_time.tomorrow, reservation_type: 'TEST_RESERVATION_TYPE2' } }
      @reservation.reload
      expect(@reservation.start_time).not_to eq(old_start_time)
      expect(@reservation.end_time).not_to eq(old_end_time)
      expect(@reservation.reservation_type).not_to eq(old_reservation_type)
    end

    it 'no change for reservation with non valid data' do
      new_start_time = @reservation.end_time + 10.day
      new_end_time = @reservation.start_time - 10.day
      post :update, params: { id: @reservation, reservation: { start_time: new_start_time, end_time: new_end_time } }
      @reservation.reload
      expect(@reservation.start_time).not_to eq(new_start_time)
      expect(@reservation.end_time).not_to eq(new_end_time)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new reservation in the database' do
        expect do
          put :create, params: { reservation: attributes_for(:reservation, item_type_id: ItemType.first) }
        end.to change(Reservation, :count).by(1)
      end
      it 'redirects to the reservation show page' do
        post :create, params: { reservation: attributes_for(:reservation, item_type_id: ItemType.first) }
        expect(response).to redirect_to Reservation.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new reservation in the database' do
        expect do
          post :create, params: { reservation: attributes_for(:invalid_date_time_reservation) }
        end.to_not change(Reservation, :count)
      end
      it 're-renders the :new template' do
        post :create, params: { reservation: attributes_for(:invalid_date_time_reservation) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the reservation from the database' do
      expect do
        delete :destroy, params: { id: reservation.id }
      end.to change(Reservation, :count).by(-1)
    end
    it 'redirects to the users index page' do
      delete :destroy, params: { id: reservation.id }
      expect(response).to redirect_to reservations_url
    end
  end
end
