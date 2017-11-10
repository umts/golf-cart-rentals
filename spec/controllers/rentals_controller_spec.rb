# frozen_string_literal: true
require 'rails_helper'

describe RentalsController do
  let(:rental_create) do
    attributes_for(:new_rental)
      .merge(renter_id: create(:user),
             rentals_items_attributes: [
               { item_type_id: create(:item_type) },
               { item_type_id: create(:item_type) }
             ])
  end

  let(:invalid_create) do
    rental = attributes_for(:invalid_rental)
    rental[:renter_id] = create(:user, first_name: 'Test_User').id
    rental
  end

  let(:mock_rental) { create :mock_rental }

  let(:item_type) { create(:item_type, name: 'TEST_ITEM_TYPE') }

  let(:item) { create(:item, name: 'TEST_ITEM') }

  before(:each) do
    # we want a new user for each
    # which has permission to assign anyone for ease of use
    u = create :user, groups: [
      create(:group, permissions: [
               create(:permission, controller: 'rentals', action: 'assign_anyone'),
               create(:permission, controller: 'rentals', action: 'view_any')
             ])
    ]

    current_user(u)
  end

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
    context 'retrieves cost' do
      it 'returns a cost for a single item type' do
        start_time = Date.today
        end_time = Date.tomorrow
        get :cost, params: { item_types: [item_type], start_time: start_time, end_time: end_time }
        expect(response).to have_http_status(:ok)
        cost = item_type.cost(start_time, end_time)
        expect(JSON.parse(response.body)).to include('_total' => cost, item_type.name => cost)
      end
      it 'returns costs for multiple item types' do
        start_time = Date.today
        end_time = Date.tomorrow
        item_types = create_list :item_type, 2
        get :cost, params: { item_types: item_types, start_time: start_time, end_time: end_time }
        expect(response).to have_http_status(:ok)
        cost = item_type.cost(start_time, end_time)
        expect(JSON.parse(response.body)).to include('_total' => cost * 2, item_types.first.name => cost, item_types.second.name => cost)
      end
      it 'returns the cost for two of the same item' do
        start_time = Date.today
        end_time = Date.tomorrow
        item_type = create :item_type
        get :cost, params: { item_types: [item_type, item_type], start_time: start_time, end_time: end_time }
        expect(response).to have_http_status(:ok)
        cost = item_type.cost(start_time, end_time)
        expect(JSON.parse(response.body)).to include('_total' => cost * 2)
      end
    end

    context 'handling errors' do
      it 'can handle invalid item id' do
        get :cost, params: { item_types: [-1], start_time: Date.today, end_time: Date.tomorrow }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to include('errors' => ['item not found -1'])
      end
      it 'can handle invalid params' do
        get :cost, params: { end_time: Date.tomorrow }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to include('errors' => ['missing_params: start_time, item_types'])
      end
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

    it 'wont render if they dont have permission' do
      current_user # unprivileged user
      get :show, params: { id: @rental }
      expect(response).to render_template('errors/401.html.erb')
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
        current_user(u) # set current_user to u in the controller
        get :new
        expect(assigns[:users].collect { |user| user[:id] }).to match_array (@dept_one_users + @other_users).collect(&:id)
      end

      it 'only assigns users in the same dept if they do not have the special permission' do
        current_user(@dept_one_users.first) # set current_user to some user from dept one in the controller
        get :new
        expect(assigns[:users].collect { |user| user[:id] }).to match_array @dept_one_users.collect(&:id)
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
        # token input gives array so we are testing renter id as array
        rental_create[:renter_id] = [rental_create[:renter_id]]
        expect do
          post :create, params: { rental: rental_create }
        end.to change(Rental, :count).by(1)
        expect(response).to redirect_to Rental.last
      end

      it 'creates associated reservation' do
        fixed_uuid = SecureRandom.uuid
        allow(Inventory).to receive(:create_reservation) { { uuid: fixed_uuid, item: { name: create(:item).name } } }
        expect do
          post :create, params: { rental: rental_create }
        end.to change(RentalsItem, :count).by(2)
        expect(RentalsItem.last(2).collect(&:reservation_id)).to contain_exactly fixed_uuid, fixed_uuid
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new rental in the database' do
        expect do
          post :create, params: { rental: invalid_create }
        end.to_not change(Rental, :count)
        expect(response).to redirect_to(action: :new)

      end
    end

    context 'inventory does not create' do
      it 'renders new and flashes warning if inventory api returns invalid response' do
        allow(Inventory).to receive(:create_reservation).and_return({}) # wont do it
        expect do
          post :create, params: { rental: rental_create } # sends valid params
        end.not_to change(Rental, :count)

        expect(flash[:warning]).to be_any { |warning| warning =~ /Reservations  rolled back #<RuntimeError: Reservation UUID was not present in response\.>/ }
        expect(response).to redirect_to(action: :new)
      end
    end

    context 'cost adjustment' do
      let(:cost) do
        ItemType.find(rental_create[:rentals_items_attributes].first[:item_type_id].id) # that item_type_id is actually the object itself
                .cost(rental_create[:start_time], rental_create[:end_time])
      end

      it 'adjusts the related financial transaction' do
        u = create :user, groups: [
          create(:group, permissions: [
                   create(:permission, controller: 'rentals', action: 'cost_adjustment'),
                   create(:permission, controller: 'rentals', action: 'assign_anyone')
                 ])
        ]
        current_user(u) # set current_user to u in the controller

        expect do
          post :create, params: { rental: rental_create, amount: cost + 1 }
        end.to change(FinancialTransaction, :count).by(1) && change(Rental, :count).by(1)

        expect(FinancialTransaction.last.amount).to eq cost + 1
      end

      it 'ignores if the user does not have permission' do # by default does not have this permission
        expect do
          post :create, params: { rental: rental_create, amount: cost + 1 }
        end.to(change(FinancialTransaction, :count).by(rental_create[:rentals_items_attributes].count)) && change(Rental, :count).by(1)

        expect(FinancialTransaction.last.amount).to eq cost # we asked for cost+1, but they ignored because we dont have perms
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

  describe 'PUT #update' do
    it 'properly picks up a rental' do
      put :update, params: { id: @rental.id, commit: 'Pick Up' }
      expect(@rental.reload.picked_up?).to be true
    end

    it 'properly drops off a rental' do
      @rental.pickup
      put :update, params: { id: @rental.id, commit: 'Drop Off' }
      expect(@rental.reload.dropped_off?).to be true
    end

    context 'dropping off after a late rental' do
      after do
        Timecop.return
      end

      it 'allows dropping off a rental even though it is late' do
        @rental.pickup
        Timecop.travel(@rental.end_date + 1.day) # travel to after the rental is due
        # now try to drop it off
        put :update, params: { id: @rental.id, commit: 'Drop Off' }
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
