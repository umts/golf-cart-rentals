require 'rails_helper'

describe IncurredIncidentalsController do
  let(:incurred_incidental_create) do
    inc = attributes_for(:incurred_incidental)
    inc[:incidental_type_id] = create(:incidental_type)
    inc[:rental_id] = create(:rental)
    inc
  end

  let(:invalid_create) do
    inc = attributes_for(:invalid)
    inc
  end

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

  describe 'GET #new' do
    it 'assigns a new instance of incurred incidental' do
      get :new
      expect(assigns[:incurred_incidental]).to be_a_new(IncurredIncidental)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves the new incurred incidental to the database' do
        expect do
          post :create, incurred_incidental: incurred_incidental_create
        end.to change(IncurredIncidental, :count).by(1)
      end

      it 'redirects to the show page for created incurred incidental' do
        post :create, incurred_incidental: incurred_incidental_create
        expect(response).to redirect_to IncurredIncidental.last
      end
    end

    context 'with invalid params' do
      it 'does not save the incurred incidental to the database' do
        expect do
          post :create, incurred_incidental: invalid_create
        end.to_not change(IncurredIncidental, :count)
      end

      it 'redirects to the :new template' do
        post :create, incurred_incidental: invalid_create
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested incurred_incidental to @incurred_incidental' do
      get :show, id: incurred_incidental
      expect(assigns[:incurred_incidental]).to eq(incurred_incidental)
    end
    it 'renders the :show template' do
      get :show, id: incurred_incidental
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested incurred_incidental to @incurred_incidental' do
      get :edit, id: incurred_incidental
      expect(assigns[:incurred_incidental]).to eq(incurred_incidental)
    end
    it 'renders the :edit template' do
      get :edit, id: incurred_incidental
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid params' do
      it 'updates the incurred incidental in the database' do
        post :update, id: incurred_incidental, incurred_incidental: { times_modified: 5 }
        incurred_incidental.reload
        expect(incurred_incidental.times_modified).to eq(5)
      end

      it 'redirects to the updated incurred incidentals :show page' do
        post :update, id: incurred_incidental, incurred_incidental: { times_modified: 5 }
        expect(response).to redirect_to incurred_incidental
      end
    end

    context 'with invalid params' do
      it 'does not update the incurred incidental in the database' do
        old_times_modified = incurred_incidental.times_modified
        post :update, id: incurred_incidental, incurred_incidental: attributes_for(:invalid)
        incurred_incidental.reload
        expect(incurred_incidental.times_modified).to eq(old_times_modified)
      end

      it 'renders the :edit template' do
        post :update, id: incurred_incidental, incurred_incidental: attributes_for(:invalid)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the incurred incidental from the database' do
      expect do
        delete :destroy, id: incurred_incidental
      end.to change(IncurredIncidental, :count).by(-1)
    end

    it 'redirects to the incurred incidental page' do
      delete :destroy, id: incurred_incidental
      expect(response).to redirect_to incurred_incidental
    end
  end
end
