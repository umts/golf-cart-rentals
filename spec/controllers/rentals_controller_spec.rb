# frozen_string_literal: true
require 'rails_helper'

describe RentalsController do
  let(:rental_create) do
    rental = attributes_for(:new_rental)
    rental[:item_type_id] = create(:item_type, name: 'TEST_ITEM_TYPE')
    rental[:item_id] = create(:item, name: 'TEST_ITEM')
    rental[:renter_id] = [create(:user, first_name: 'Test2')]
    rental
  end

  let(:invalid_create) do
    rental = attributes_for(:invalid_rental)
    rental[:renter_id] = [create(:user, first_name: 'Test_User')]
    rental
  end

  let(:mock_rental) { create :mock_rental }

  let(:item_type) { create(:item_type, name: 'TEST_ITEM_TYPE') }

  let(:item) { create(:item, name: 'TEST_ITEM') }

  before(:each) { current_user }

  before(:each) do
    @rental = create(:mock_rental)
    @rental2 = create(:mock_rental)
  end

  after(:each) do
    @rental.destroy
    @rental2.destroy
    Timecop.return
  end

  describe 'GET #cost' do
    it 'returns a cost based on item type' do
      start_time = Date.today
      end_time = Date.tomorrow
      get :cost, params: { item_type: item_type, start_time: start_time, end_time: end_time }
      expect(response.body).to eq(Rental.cost(start_time, end_time, item_type).to_s)
    end
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
      get :show, params: { id: @rental }
      expect(assigns[:rental]).to eq(@rental)
    end
    it 'renders the :show template' do
      get :show, params: { id: @rental }
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

    context 'assiging users for search' do
      before do
        User.destroy_all
        @dept_one = create :department
        @dept_one_users = create_list :user, 10, department: @dept_one
        @other_users = create_list :user, 10 # not in @dept_one
      end

      it 'assigns all users if that user has the permission' do
        u = @other_users.first
        g = create(:group)
        g.permissions << create(:permission, controller: 'rentals', action: 'assign_anyone')
        g.save
        u.groups << g
        u.save
        current_user(u) # set current_user to u in teh controller
        get :new
        expect(assigns[:users].collect {|user| user[:id] }).to match_array (@dept_one_users + @other_users).collect(&:id)
      end

      it 'only assigns users in the same dept if they do not have the special permission' do
        current_user(@dept_one_users.first) # set current_user to some user from dept one in teh controller
        get :new
        expect(assigns[:users].collect {|user| user[:id] }).to match_array (@dept_one_users).collect(&:id)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new rental in the database' do
        expect do
          post :create, params: { rental: rental_create }
        end.to change(Rental, :count).by(1)
      end
      it 'redirects to the rental show page' do
        post :create, params: { rental: rental_create }
        expect(response).to redirect_to Rental.last
      end

      it 'can handle a renter_id passed as an array or not' do
        rental_create[:renter_id] = rental_create[:renter_id].first
        expect do
          post :create, params: { rental: rental_create }
        end.to change(Rental, :count).by(1)
        expect(response).to redirect_to Rental.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new rental in the database' do
        expect do
          post :create, params: { rental: invalid_create }
        end.to_not change(Rental, :count)
      end
      it 're-renders the :new template' do
        post :create, params: { rental: invalid_create }
        expect(response).to render_template :new
        expect(assigns[:users]).not_to be_empty
      end

      it 'wont allow assignment of a user they do not have permission for' do
        post :create 
      end
    end

    context 'cost adjustment' do
      let(:cost) { Rental.cost(rental_create[:start_time], rental_create[:end_time], rental_create[:item_type_id]) }

      it 'adjusts the related financial transaction' do
        u = create(:user)
        g = create(:group)
        g.permissions << create(:permission, controller: 'rentals', action: 'cost_adjustment')
        g.save
        u.groups << g
        u.save
        current_user(u) # set current_user to u in teh controller

        expect do
          post :create, params: { rental: rental_create, amount: cost + 1 }
        end.to(change(FinancialTransaction, :count).by(1)) && change(Rental, :count).by(1)

        expect(FinancialTransaction.last.initial_amount).to eq cost + 1
      end

      it 'ignores if the user does not have permission' do # by default does not have this permission
        expect do
          post :create, params: { rental: rental_create, amount: cost + 1 }
        end.to(change(FinancialTransaction, :count).by(1)) && change(Rental, :count).by(1)

        expect(FinancialTransaction.last.initial_amount).to eq cost # we asked for cost+1
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
      delete :destroy, params: { id: @rental.id }
      expect(@rental.reload.canceled?).to be true
    end

    it 'refuses to cancel a rental in progress' do
      @rental.pickup
      delete :destroy, params: { id: @rental.id }
      expect(@rental.reload.picked_up?).to be true
    end

    it 'remains canceled if already canceled' do
      @rental.cancel!
      delete :destroy, params: { id: @rental.id }
      expect(@rental.reload.canceled?).to be true
    end
  end

  describe 'GET #transform' do
    it 'redirects to drop_off page if it was checked out' do
      rental = mock_rental
      rental.pickup
      get :transform, params: { id: rental.id }
      expect(response).to render_template :drop_off
    end

    it 'redirects to pickup page if it was reserved' do
      get :transform, params: { id: mock_rental.id }
      expect(response).to render_template :pickup
    end

    it 'handles the no show flag correctly' do
      rental = create(:mock_rental, start_time: Date.current, end_time: DateTime.current.next_day)
      Timecop.freeze(DateTime.current + 23.hours)
      get :transform, params: { id: rental.id }
      expect(response).to render_template :pickup
      Timecop.return
      Timecop.freeze(DateTime.current + 1.day)
      get :transform, params: { id: rental.id }
      expect(response).to render_template :no_show_form
    end

    it 'redirects to rentals if passed a rental that is not reserved or picked up' do
      rental = mock_rental
      rental.cancel!
      get :transform, params: { id: rental.id }
      expect(response).to render_template :index
    end
  end

  describe 'GET #invoice' do
    it 'assigns a requested rental to @rental' do
      get :invoice, params: { id: @rental }
      expect(assigns[:rental]).to eq @rental
    end

    it 'all requested financial transactions should contain the same rental as @rental' do
      get :show, params: { id: @rental }
      expect(assigns[:financial_transactions].pluck(:rental_id).uniq).to eq([@rental.id])
    end
  end

  # unless i'm mistaken this is not an action anymore, just a partial
  # describe 'GET #transaction_detail' do
  # it 'assigns a requested rental to @rental' do
  # get :transaction_detail, params: { id: @rental.id }
  # expect(assigns[:rental]).to eq @rental
  # end

  # it 'all requested financial transactions should contain the same rental as @rental' do
  # get :transaction_detail, params: { id: @rental }
  # expect(assigns[:financial_transactions].all? { |ft| ft.rental.id == @rental.id }).to be true
  # end
  # end

  describe 'PUT #update' do
    it 'properly picks up a rental' do
      expect do
        put :update, params: { id: @rental.id, rental: { customer_signature_image: 'something' }, commit: 'Pick Up' }
      end.to change(DigitalSignature, :count).by(1)
      expect(DigitalSignature.last.pickup?).to be true
      expect(@rental.reload.picked_up?).to be true
    end

    it 'properly drops off a rental' do
      @rental.pickup
      expect do
        put :update, params: { id: @rental.id, rental: { customer_signature_image: 'something' }, commit: 'Drop Off' }
      end.to change(DigitalSignature, :count).by(1)
      expect(DigitalSignature.last.drop_off?).to be true
      expect(@rental.reload.dropped_off?).to be true
    end

    context 'dropping off after a late rental' do
      after do
        Timecop.return
      end

      it 'allows dropping off a rental even though it is late' do
        @rental.pickup
        Timecop.travel(@rental.end_date+1.day) # travel to after the rental is due
        # now try to drop it off
        put :update, params: {id: @rental.id, rental: { customer_signature_image: 'something'}, commit: 'Drop Off'}
        # it should be dropped off
        expect(@rental.reload.dropped_off?).to be true
      end
    end

    it 'properly processes a no show' do
      Timecop.freeze(Time.current + 1.day)
      put :update, params: { id: @rental.id, commit: 'Process No Show' }
      expect(@rental.reload.canceled?).to be true
    end

    it 'change a rental' do
      put :update, params: { id: @rental.id, rental: { start_time: @rental.start_time + 1.hour } }
    end
  end
end
