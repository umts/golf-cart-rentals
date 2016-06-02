require 'rails_helper'

describe RentalsController do
  let(:rental_create) do
    rental = attributes_for(:new_rental)
    rental[:item_type_id] = create(:item_type, name: 'TEST_ITEM_TYPE')
    rental
  end

  before(:each) { current_user }

  before(:each) do
    item_type = create(:item_type, name: 'TEST_ITEM_TYPE')
    @rental = create(:rental, item_type: item_type)
    @rental2 = create(:rental, item_type: item_type)
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
            post :create, rental: attributes_for(:new_rental)
          end.to_not change(Rental, :count)
        end
        it 're-renders the :new template' do
          post :create, rental: attributes_for(:new_rental)
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
      request.env['HTTP_REFERER'] = 'back_page'
      @rental_to_destroy = create(:valid_rental, item_type: create(:item_type, name: 'TEST_ITEM_TYPE'))
    end
    it 'deletes the rental from the database' do
      expect do
        delete :destroy, id: @rental_to_destroy
      end.to change(Rental, :count).by(-1)
    end
    it 'redirects back a page' do
      delete :destroy, id: @rental_to_destroy
      expect(response).to redirect_to 'back_page'
    end
  end
end