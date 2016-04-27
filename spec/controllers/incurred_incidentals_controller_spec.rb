require 'rails_helper'

RSpec.describe IncurredIncidentalsController, type: :controller do

  before(:each) do
    @rental = create(:rental)
    @incidental1 = create(:incurred_incidental, rental_id: @rental.id)
    @incidental2 = create(:incurred_incidental, rental_id: @rental.id)

    @note = create(:note)
    @incidental1.notes << @note
  end

  describe 'GET #index' do
    it 'renders the :index view' do
      get :index, { rental_id: @rental.id }
      expect(response).to render_template :index
    end

    it 'populates an array of incidentals' do
      get :index, { rental_id: @rental.id }
      expect(assigns[:incidentals]).to eq([@incidental1, @incidental2])
    end
  end

  describe 'GET #show' do
    it 'renders the :show template' do
      get :show, { rental_id: @rental.id, id: @incidental1.id }
      expect(response).to render_template :show
    end

    it 'assigns the requested incidental to @incidental1' do
      get :show, { rental_id: @rental.id, id: @incidental1.id }
      expect(assigns[:incidental]).to eq(@incidental1)
    end
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new, { rental_id: @rental.id }
      expect(response).to render_template :new
    end

    it 'assigns a new incidental to @incidental1' do
      get :new, { rental_id: @rental.id }
      expect(assigns[:incidental]).to be_a_new(IncurredIncidental)
    end
  end

=begin

  # Issues with passing in correct test params for creating a new note
  # Similar issues with 'POST #update'

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new incidental in the database' do
        expect do
          post :create, { rental_id: @rental.id,
                          incurred_incidental: { times_modified: 0, incidental_type_id: 1, is_active: true },
                          note: "test" }  # need correct way to pass in params[:incidental][:note][:note]
        end.to change(IncurredIncidental, :count).by(1)
      end

      post :create, { rental_id: @rental.id,
                      incurred_incidental: { times_modified: 0, incidental_type_id: 1, is_active: true },
                      note: "test" }      # need correct way to pass in params[:incidental][:note][:note]
        expect(response).to redirect_to IncurredIncidental.last
      end
    end
  end

=end

  describe 'GET #edit' do
    it 'renders the :edit template' do
      get :edit, { rental_id: @rental.id, id: @incidental1.id }
      expect(response).to render_template :edit
    end

    it 'assigns the requested incidental to @incidental1' do
      get :edit, { rental_id: @rental.id, id: @incidental1.id }
      expect(assigns[:incidental]).to eq(@incidental1)
    end
  end
end
