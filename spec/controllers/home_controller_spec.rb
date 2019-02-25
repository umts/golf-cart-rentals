# frozen_string_literal: true
require 'rails_helper'

describe HomeController do
  let!(:rental) { create :rental }
  let!(:rental2) { create :rental }
  let!(:upcoming) { create :rental, :upcoming }
  let!(:upcoming2) { create :rental, :upcoming, start_time: DateTime.current }
  let!(:past) { create :rental, :past }
  let!(:past2) { create :rental, :past }
  let!(:future) do
    create :rental,
      start_time: 8.days.since,
      end_time: 9.days.since
  end
  let!(:ongoing) { create :rental, :ongoing }
  let!(:ongoing2) { create :rental, :ongoing}
  let!(:canceled) { create :rental, rental_status: 'canceled' }

  let!(:item_type) { create(:item_type) }
  let!(:item_type2) { create(:item_type) }

  describe 'GET #index' do
    describe 'for admin user' do
      before(:each) do
        current_user(create(:admin_user))
      end
      it 'populates an array of rentals' do
        get :index
        expect(assigns[:rentals]).to include(rental, upcoming, past, future, rental2, ongoing)
      end

      it 'populates an array of upcoming rentals' do
        upcoming2
        get :index
        expect(assigns[:upcoming_rentals]).to include(rental, upcoming, upcoming2)
        expect(assigns[:upcoming_rentals]).not_to include(future, past, ongoing)
      end

      it 'populates an array of past rentals' do
        past2
        canceled
        get :index
        expect(assigns[:past_rentals]).to include(past, past2, canceled)
        expect(assigns[:past_rentals]).not_to include(rental, upcoming, future, ongoing)
      end

      it 'populates an array of future rentals' do
        get :index
        expect(assigns[:future_rentals]).to include(rental, upcoming, future)
        expect(assigns[:future_rentals]).not_to include(past, ongoing)
      end

      it 'populates an array of ongoing rentals' do
        ongoing2
        get :index
        expect(assigns[:ongoing_rentals]).to include(ongoing, ongoing2)
        expect(assigns[:ongoing_rentals]).not_to include(rental, upcoming, past, future)
      end

      it 'populates an array of item_types' do
        get :index
        expect(assigns[:item_types]).to include(item_type, item_type2)
      end
    end

    describe 'for non_admin user' do
      before(:each) do
        @user = current_user
        @other_user = create(:admin_user)
        @rental = create :rental, renter_id: @user.id, creator_id: @user.id
        @rental2 = create :rental, :ongoing, renter_id: @user.id, creator_id: @user.id
        @rental3 = create :rental, renter_id: @other_user.id, creator_id: @other_user.id
      end

      it 'filters out rentals not belonging to the current user' do
        get :index
        expect(assigns[:rentals]).to contain_exactly @rental, @rental2
      end
    end

    it 'handles an error by sending an email' do
      allow_any_instance_of(HomeController).to receive(:index).and_raise(StandardError.new)
      # in application controller we rescue exceptions with render 500
      expect_any_instance_of(ApplicationController).to receive(:render_500)
      get :index
    end
  end
end
