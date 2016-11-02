require 'rails_helper'

describe HomeController do
  let(:rental) { create :mock_rental, reservation_id: 1111 }
  let(:rental2) { create :mock_rental, reservation_id: 2222 }
  let(:upcoming) { create :upcoming_rental, reservation_id: 3333 }
  let(:upcoming2) { create :upcoming_rental, start_time: DateTime.current, reservation_id: 4444 }
  let(:past) { create :past_rental, reservation_id: 5555 }
  let(:past2) { create :past_rental, reservation_id: 6666 }
  let(:future) { create :far_future_rental, reservation_id: 7777 }
  let(:ongoing) { create :ongoing_rental, reservation_id: 8888 }
  let(:ongoing2) { create :ongoing_rental, reservation_id: 9999 }
  let(:canceled) { create :mock_rental, rental_status: 'canceled', reservation_id: 0000 }

  let!(:item_type) { create(:item_type) }
  let!(:item_type2) { create(:item_type) }

  describe 'GET #index' do
    describe 'for admin user' do
      before(:each) do
        current_user(create(:admin_user))
        rental
        upcoming
        ongoing
        past
        future
      end
      it 'populates an array of rentals' do
        rental2
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
      end

      it 'filters out rentals not belonging to the current user' do
        get :index
        expect(assigns[:rentals]).to include(create(:mock_rental, user_id: @user.id ), create(:ongoing_rental, user_id: @user.id))
        expect(assigns[:rentals]).not_to include(create(:mock_rental, user_id: @other_user.id))
      end
    end
  end
end
