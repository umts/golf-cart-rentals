require 'rails_helper'

describe IncurredIncidentalsController do
  let!(:incurred_incidental) {create(:incurred_incidental)}
  let!(:incurred_incidental2) {create(:incurred_incidental)}

  describe 'GET #index' do
    it 'polulates an array of incurred incidental' do
      get :index
      expect(assigns[:incurred_incidentals]).to eq([incurred_incidental, incurred_incidental2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested incurred_incidental to @incurred_incidental' do
      get :show, params: { id: incurred_incidental }
      expect(assigns[:incurred_incidental]).to eq(incurred_incidental)
    end
    it 'renders the :show template' do
      get :show, params: { id: incurred_incidental }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested incurred_incidental to @incurred_incidental' do
      get :edit, params: { id: incurred_incidental }
      expect(assigns[:incurred_incidental]).to eq(incurred_incidental)
    end
    it 'renders the :edit template' do
      get :edit, params: { id: incurred_incidental }
      expect(response).to render_template :edit
    end
  end

end
