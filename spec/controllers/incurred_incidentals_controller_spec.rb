# frozen_string_literal: true
require 'rails_helper'
include ActionDispatch::TestProcess
describe IncurredIncidentalsController do
  let(:incurred_incidental_create) do
    inc = attributes_for(:incurred_incidental)
    inc[:rental_id] = create(:rental).id
    inc[:incidental_type_id] = create(:incidental_type).id
    inc[:amount] = 0
    inc[:notes_attributes] = { '0': { note: 'hey wassup hello' } }
    inc
  end

  let(:invalid_create) do
    inc = attributes_for(:invalid_incidental)
    inc
  end

  let!(:incurred_incidental) { create(:incurred_incidental) }
  let!(:incurred_incidental2) { create(:incurred_incidental) }

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
      get :new, params: { rental_id: incurred_incidental.rental_id }
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves the new incurred incidental to the database' do
        expect do
          post :create, params: { incurred_incidental: incurred_incidental_create }
        end.to change(IncurredIncidental, :count).by(1)
      end

      context 'redirection' do
        it 'redirects to the show page for created incurred incidental without damage tracking' do
          post :create, params: { incurred_incidental: incurred_incidental_create }
          expect(response).to redirect_to IncurredIncidental.last
        end

        it 'redirects to the show page for created incurred incidental with damage tracking' do
          ii = incurred_incidental_create.merge(incidental_type_id: create(:incidental_type, damage_tracked: true))
          post :create, params: { incurred_incidental: ii }

          expect(response).to redirect_to new_damage_path(incurred_incidental_id: IncurredIncidental.last) # to create the damage tracking
        end
      end
    end

    context 'with invalid params' do
      it 'does not save the incurred incidental to the database' do
        expect do
          post :create, params: { incurred_incidental: invalid_create }
        end.to_not change(IncurredIncidental, :count)
      end

      it 'redirects to the :new template' do
        post :create, params: { incurred_incidental: invalid_create }
        expect(response).to render_template :new
      end
    end

    context 'with optional document' do
      it 'takes a document and saves it' do
        desc = 'some desc'
        expect do
          post :create, params: { incurred_incidental: incurred_incidental_create,
                                  file: { '1' => fixture_file_upload('file.png', 'image/png') }, desc: { '1' => desc } }
        end.to change(Document, :count).by(1)
        expect(IncurredIncidental.last.documents).to be_present
        expect(Document.last.description).to eq(desc)
        expect(Document.last.original_filename).to eq('file.png')
      end

      it 'handles multiple documents' do
        expect do
          post :create, params: { incurred_incidental: incurred_incidental_create,
                                  file: { '1' => fixture_file_upload('file.png', 'image/png'),
                                          '2' => fixture_file_upload('file.txt', 'text/plain') },
                                  desc: { '1' => 'some desc', '2' => 'another desc' } }
        end.to change(Document, :count).by(2)
      end
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

  describe 'POST #update' do
    context 'with valid params' do
      it 'updates the incurred incidental in the database' do
        post :update, params: { id: incurred_incidental, incurred_incidental: { amount: 5 } }
        incurred_incidental.reload
        expect(incurred_incidental.amount).to eq(5)
      end

      it 'redirects to the updated incurred incidentals :show page' do
        post :update, params: { id: incurred_incidental, incurred_incidental: { amount: 5 } }
        expect(response).to redirect_to incurred_incidental
      end
    end

    context 'with invalid params' do
      it 'does not update the incurred incidental in the database' do
        old_amount = incurred_incidental.amount
        post :update, params: { id: incurred_incidental, incurred_incidental: attributes_for(:invalid_incidental) }
        incurred_incidental.reload
        expect(incurred_incidental.amount).to eq(old_amount)
      end

      it 'renders the :edit template' do
        post :update, params: { id: incurred_incidental, incurred_incidental: attributes_for(:invalid_incidental) }
        expect(response).to render_template :edit
      end
    end
  end
end
