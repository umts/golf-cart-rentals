# frozen_string_literal: true
require 'rails_helper'
include ActionDispatch::TestProcess
describe IncurredIncidentalsController do
  let(:incurred_incidental_create) do
    inc = attributes_for(:incurred_incidental)
    inc[:rental_id] = create(:rental).id
    inc[:incidental_type_id] = create(:incidental_type).id
    inc[:notes_attributes] = { '0': { note: 'hey wassup hello' } }
    inc[:financial_transaction_attributes] = { amount: 44 }
    inc
  end

  let(:invalid_create) do
    attributes_for(:invalid_incidental)
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
      context 'time travel' do
        it 'can create a incurred incidental past rental start date' do
          Timecop.travel(Rental.find(incurred_incidental_create[:rental_id]).start_date + 1.day)
          expect do
            post :create, params: { incurred_incidental: incurred_incidental_create }
          end.to change(IncurredIncidental, :count).by(1)
        end

        after do
          Timecop.return
        end
      end

      it 'creates a financial transaction linked to the same rental' do
        post :create, params: { incurred_incidental: incurred_incidental_create }
        incurred_incidental = IncurredIncidental.last
        financial_transaction = incurred_incidental.financial_transaction
        expect(financial_transaction).not_to be_nil
        expect(incurred_incidental.rental).to eq(financial_transaction.rental)
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
        expect(response).to redirect_to new_incurred_incidental_path
      end
    end

    context 'with document' do
      it 'takes a document and saves it' do
        desc = 'some desc'
        expect do
          post :create, params: { incurred_incidental: incurred_incidental_create.merge(
            documents_attributes: {
              '0' => { uploaded_file: fixture_file_upload('file.png', 'image/png'), description: desc }
            }
          ) }
        end.to change(Document, :count).by(1)
        expect(IncurredIncidental.last.documents).to be_present
        expect(Document.last.description).to eq(desc)
        expect(Document.last.original_filename).to eq('file.png')
      end

      it 'handles multiple documents' do
        expect do
          post :create, params: { incurred_incidental: incurred_incidental_create.merge(
            documents_attributes: {
              '0' => { uploaded_file: fixture_file_upload('file.png', 'image/png'), description: 'somedesc' },
              '1' => { uploaded_file: fixture_file_upload('file.txt', 'text/plain'), description: 'somedesc' }
            }
          ) }
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
        post :update, params: { id: incurred_incidental, incurred_incidental: { financial_transaction_attributes: { amount: 5 } } }
        incurred_incidental.reload
        expect(incurred_incidental.financial_transaction.amount).to eq(5)
      end

      it 'redirects to the updated incurred incidentals :show page' do
        post :update, params: { id: incurred_incidental, incurred_incidental: { financial_transaction_attributes: { amount: 5 } } }
        expect(response).to redirect_to incurred_incidental
      end
    end

    context 'with invalid params' do
      it 'does not update the incurred incidental in the database' do
        old_type_id = incurred_incidental.incidental_type_id
        post :update, params: { id: incurred_incidental, incurred_incidental: attributes_for(:invalid_incidental) }
        incurred_incidental.reload
        expect(incurred_incidental.incidental_type_id).to eq(old_type_id)
      end

      it 'redirects to :edit' do
        post :update, params: { id: incurred_incidental, incurred_incidental: attributes_for(:invalid_incidental) }
        expect(response).to redirect_to edit_incurred_incidental_path
      end
    end

    context 'updating documents' do
      it 'refuses to update given empty desc of existing doc' do
        ii = create :incurred_incidental
        doc1 = create(:document, description: 'not_test')
        doc2 = create(:document, description: 'other_desc')
        ii.documents << [doc1, doc2]

        post :update, params: { id: ii, incurred_incidental: { documents_attributes: {
          '0' => { 'description' => '', id: doc1 },
          '1' => { 'description' => 'test', id: doc2 }
        } } }
        expect(doc1.reload.description).to eq 'not_test' # has refused to update doc1
        expect(doc2.reload.description).to eq 'test'
      end

      it 'adds a new document' do
        ii = create :incurred_incidental
        expect(ii.documents.count).to be 0 # sanity check
        expect do
          post :update, params: {
            id: ii, incurred_incidental: { documents_attributes: {
              '0' => { uploaded_file: fixture_file_upload('file.png', 'image/png'), description: 'somedesc' }
            } }
          }
        end.to change(Document, :count).by(1)
        expect(ii.documents.reload.count).to be 1
      end

      it 'deletes documents' do
        ii = create :incurred_incidental
        ii.documents << create(:document, description: 'not_test')
        ii.documents << create(:document, description: 'other_desc')
        post :update, params: { id: ii, incurred_incidental: { documents_attributes: {
          '0' => { id: ii.documents.first }
        } } }
        expect(ii.documents.reload.count).to be 1
        expect(ii.documents.first.description).to eq 'other_desc'
      end
    end
  end
end
