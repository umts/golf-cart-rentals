require 'rails_helper'

describe RentalsController do
  let(:rental_create) do
    rental = attributes_for(:new_rental)
    rental[:item_type_id] = create(:item_type, name: 'TEST_ITEM_TYPE')
    rental[:item_id] = create(:item, name: "TEST_ITEM")
    rental[:user_id] = create(:user, first_name: 'Test2')
    rental
  end

  let(:invalid_create) do
    rental = attributes_for(:invalid_rental)
    rental[:user_id] = create(:user, first_name: 'Test_User')
    rental
  end

  let(:mock_rental) { create :mock_rental }

  let(:item_type) { create(:item_type, name: 'TEST_ITEM_TYPE') }

  let(:item) { create(:item, name: "TEST_ITEM") }

  before(:each) { current_user }

  before(:each) do
    @rental = create(:mock_rental)
    @rental2 = create(:mock_rental)
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
      it 'saves the new rental in the database' do
        expect do
          post :create, rental: rental_create
        end.to change(Rental, :count).by(1)
      end
      it 'redirects to the rental show page' do
        post :create, rental: rental_create
        expect(response).to redirect_to Rental.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new rental in the database' do
        expect do
          post :create, rental: invalid_create
        end.to_not change(Rental, :count)
      end
      it 're-renders the :new template' do
        post :create, rental: invalid_create
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #processing' do
    it 'populates an array of rentals' do
      get :processing
      expect(assigns[:rentals]).to eq([@rental, @rental2])
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

  describe 'GET #transaction_detail' do
    it 'assigns a requested retnal to @rental'do
      get :transaction_detail, id: @rental
      expect(assigns[:rental]).to eq @rental
    end

    it 'all requsted financial transactions should contain the same rental as @rental' do
      get :transaction_detail, id: @rental
      expect(assigns[:financial_transactions].all?{|ft| ft.rental.id == @rental.id}).to be true
    end
  end

  describe 'PUT #update' do
    it 'properly checks out a rental' do
      expect do
        put :update, id: @rental.id, rental: { customer_signature_image: 'something' }, commit: 'Check Out'
      end.to change(DigitalSignature, :count).by(1)
      expect(DigitalSignature.last.check_out?).to be true
      expect(@rental.reload.checked_out?).to be true
    end

    it 'properly checks in a rental' do
      @rental.pickup
      expect do
        put :update, id: @rental.id, rental: { customer_signature_image: 'something' }, commit: 'Check In'
      end.to change(DigitalSignature, :count).by(1)
      expect(DigitalSignature.last.check_in?).to be true
      expect(@rental.reload.checked_in?).to be true
    end

    it 'change a rental' do
      put :update, id: @rental.id, rental: { start_time: @rental.start_time + 1.hour }
    end
  end
end
