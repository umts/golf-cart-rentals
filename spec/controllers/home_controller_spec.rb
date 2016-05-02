require 'rails_helper'

describe HomeController do
  let!(:rental) { create(:rental) }
  let!(:rental2) { create(:rental) }

  let!(:item_type) { create(:item_type) }
  let!(:item_type2) { create(:item_type) }

  before(:each) { current_user }

  describe 'GET #index' do
    it 'populates an array of rentals' do
      get :index
      expect(assigns[:rentals]).to eq([rental, rental2])
    end

    it 'populates an array of upcoming rentals'
    it 'populates an array of past rentals'

    it 'populates an array of item_types' do
      get :index
      expect(assigns[:item_types]).to eq([item_type, item_type2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
