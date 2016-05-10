require 'rails_helper'

describe HomeController do
  before do
    @item_type = create(:item_type, name: 'TEST_ITEM_TYPE')
  end
  
  before(:each) {
    @rental = create :rental, item_type: @item_type
    @rental2 = create :rental, item_type: @item_type
  }

  after(:each){
    @rental.destroy
    @rental2.destroy
  }

  let!(:item_type) { create(:item_type) }
  let!(:item_type2) { create(:item_type) }

  before(:each) { current_user }

  describe 'GET #index' do
    it 'populates an array of rentals' do
      get :index
      expect(assigns[:rentals]).to eq([@rental, @rental2])
    end

    it 'populates an array of upcoming rentals'
    it 'populates an array of past rentals'

    it 'populates an array of item_types' do
      get :index
      expect(assigns[:item_types]).to eq([@item_type, item_type, item_type2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
