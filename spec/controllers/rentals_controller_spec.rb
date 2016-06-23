require 'rails_helper'

describe RentalsController do
  let(:rental_create) do
    rental = attributes_for(:new_rental)
    rental[:item_type_id] = create(:item_type, name: 'TEST_ITEM_TYPE')
    rental[:user_id] = create(:user, first_name: 'Test2')
    rental
  end

  let(:mock_rental) { create :mock_rental }

  let(:item_type) { create(:item_type, name: 'TEST_ITEM_TYPE') }

  before(:each) { current_user }

  before(:each) do
    #binding.pry
    @rental = create(:rental)
    @rental2 = create(:rental)
  end

  after(:each) do
    @rental.destroy
    @rental2.destroy
  end

  describe 'GET #index' do
    it 'populates an array of rentals' do
      get :index
      expect(assigns[:rentals]).to eq([@rental, @rental2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested rental to @rental' do
      get :show, id: @rental
      expect(assigns[:rental]).to eq(@rental)
    end
    it 'renders the :show template' do
      get :show, id: @rental
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new rental to @rental' do
      get :new
      expect(assigns[:rental]).to be_a_new(Rental)
    end
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      context 'with accepting the disclaimer' do
        after :each do
          Rental.last.destroy
        end
        it 'saves the new rental in the database' do
          expect do
            post :create, rental: rental_create, disclaimer: '1'
          end.to change(Rental, :count).by(1)
        end
        it 'redirects to the rental page' do
          expect do
            post :create, rental: rental_create, disclaimer: '1'
            expect(response).to redirect_to Rental.last
          end
        end
      end

      context 'without accepting the disclaimer' do
        it 'does not save the new Rental in the database' do
          expect do
            post :create, rental: attributes_for(:rental)
          end.to_not change(Rental, :count)
        end
        it 're-renders the :new template' do
          post :create, rental: attributes_for(:rental)
          expect(response).to render_template :new
        end
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new Rental in the database' do
        expect do
          post :create, rental: attributes_for(:invalid_rental), disclaimer: '1'
        end.to_not change(Rental, :count)
      end
      it 're-renders the :new template' do
        post :create, rental: attributes_for(:invalid_rental), disclaimer: '1'
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #destroy' do
    before :each do
      request.env['http_referer'] = 'back_page'
    end

    it 'cancels the rental' do
      delete :destroy, id: @rental.id
      expect(@rental.reload.canceled?).to be true
    end

    it 'refuses to cancel a rental in progress' do
      @rental.pickup
      delete :destroy, id: @rental.id
      expect(@rental.reload.checked_out?).to be true
    end
  end

  describe 'GET #transform' do
    it 'redirects to check in page if it was checked out' do
      rental = mock_rental
      rental.pickup
      get :transform, id: rental.id
      expect(response).to render_template :check_in
    end

    it 'redirects to check out page if it was reserved' do
      get :transform, id: mock_rental.id
      expect(response).to render_template :check_out
    end

    it 'redirects to rentals if passed a rental that is not reserved or checked out' do
      rental = mock_rental
      rental.cancel!
      get :transform, id: rental.id
      expect(response).to render_template :index
    end
  end

  describe 'PUT #update' do
    it 'properly checks out a rental' do
      expect do
        put :update, id: @rental.id, rental: { csr_signature_image: 'something', customer_signature_image: 'a different thing' }, commit: 'Check Out'
      end.to change(DigitalSignature, :count).by(2)
      expect(DigitalSignature.last.check_out?).to be true
      expect(@rental.reload.checked_out?).to be true
    end

    it 'properly checks in a rental' do
      @rental.pickup
      expect do
        put :update, id: @rental.id, rental: { csr_signature_image: 'something', customer_signature_image: 'a different thing' }, commit: 'Check In'
      end.to change(DigitalSignature, :count).by(2)
      expect(DigitalSignature.last.check_in?).to be true
      expect(@rental.reload.checked_in?).to be true
    end

    it 'change a rental' do
      put :update, id: @rental.id, rental: { start_time: @rental.start_time + 1.hour }
    end
  end
end
