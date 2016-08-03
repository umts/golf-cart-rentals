require 'rails_helper'

describe IncidentalTypesController do
  let!(:incidental_type) {create(:incidental_type)}
  let!(:incidental_type2) {create(:incidental_type)}

  describe 'GET #index' do
    it 'polulates an array of incidental type' do
      get :index
      expect(assigns[:incidental_types]).to eq([incidental_type, incidental_type2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested incidental_type to @incidental_type' do
      get :show, params: { id: incidental_type }
      expect(assigns[:incidental_type]).to eq(incidental_type)
    end
    it 'renders the :show template' do
      get :show, params: { id: incidental_type }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested incidental_type to @incidental_type' do
      get :edit, params: { id: incidental_type }
      expect(assigns[:incidental_type]).to eq(incidental_type)
    end
    it 'renders the :edit template' do
      get :edit, params: { id: incidental_type }
      expect(response).to render_template :edit
    end
  end

  describe 'GET #new' do
    it 'assigns a new incidental_type to @incidental_type' do
      get :new
      expect(assigns[:incidental_type]).to be_a_new(IncidentalType)
    end
  end

end
