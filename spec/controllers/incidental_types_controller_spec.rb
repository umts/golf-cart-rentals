require 'rails_helper'

describe IncidentalTypesController do
  let(:incidental_type_create) do
    inc_type = attributes_for(:incidental_type)
    inc_type
  end

  let(:invalid_incidental) do
    inc_type = attributes_for(:invalid_type)
  end

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

  describe 'POST #update' do
    context 'with valid params' do
      it 'updates the type in the database' do
        post :update, params: { id: incidental_type, incidental_type: { name: 'new type' } }
        incidental_type.reload
        expect(incidental_type.name).to eq('new type')
      end

      it 'redirects to the show page for that type' do
        post :update, params: { id: incidental_type, incidental_type: { name: 'new type' } }
        expect(response).to redirect_to incidental_type
      end
    end

    context 'with invalid params' do
      it 'does not update the type in the database' do
        old_name = incidental_type.name
        post :update, params: { id: incidental_type, incidental_type: attributes_for(:invalid_type) }
        incidental_type.reload
        expect(incidental_type.name).to eq(old_name)
      end

      it 'renders the :edit page' do
        post :update, params: { id: incidental_type, incidental_type: attributes_for(:invalid_type) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new incidental_type to @incidental_type' do
      get :new
      expect(assigns[:incidental_type]).to be_a_new(IncidentalType)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves a new incidental type to the database' do
        expect do
          post :create, params: { incidental_type: incidental_type_create }
        end.to change(IncidentalType, :count).by(1)
      end

      it 'redirects to the show page for the new incidental type' do
        post :create, params: { incidental_type: incidental_type_create }
        expect(response).to redirect_to IncidentalType.last
      end
    end

    context 'with invalid params' do
      it 'does not save the incidental type to the database' do
        expect do
          post :create, params: { incidental_type: invalid_incidental }
        end.to_not change(IncidentalType, :count)
      end

      it 'renders the :new template' do
        post :create, params: { incidental_type: invalid_incidental }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the incidental type from the database' do
      expect do
        delete :destroy, params: { id: incidental_type }
      end.to change(IncidentalType, :count).by(-1)
    end

    it 'redirects to the incidental type index page' do
      delete :destroy, params: { id: incidental_type }
      expect(response).to redirect_to incidental_types_path
    end
  end
end
