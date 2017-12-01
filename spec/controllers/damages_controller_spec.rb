# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DamagesController, type: :controller do
  let!(:damage) { create(:damage) }
  let!(:damage2) { create(:damage) }

  describe 'GET #index' do
    it 'populates an array of damages' do
      get :index
      expect(assigns[:damages]).to eq([damage, damage2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested damage do @damage' do
      get :show, params: { id: damage }
      expect(assigns[:damage]).to eq(damage)
    end
    it 'renders the :show template' do
      get :show, params: { id: damage }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new damage to @damage' do
      get :new
      expect(assigns[:damage]).to be_a_new(Damage)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new damage in the database' do
        expect do
          post :create, params: { damage: build(:damage).attributes }
        end.to change(Damage, :count).by(1)
      end

      it 'redirects to the damage page' do
        post :create, params: { damage: build(:damage).attributes }
        expect(response).to redirect_to Damage.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new damage in the database' do
        expect do
          post :create, params: { damage: attributes_for(:invalid_damage) }
        end.to_not change(Damage, :count)
      end
      it 're-renders the :new template' do
        post :create, params: { damage: attributes_for(:invalid_damage) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested damage to @damage' do
      get :edit, params: { id: damage }
      expect(assigns[:damage]).to eq(damage)
    end
    it 'renders the :edit template' do
      get :edit, params: { id: damage }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the damage in the database' do
        new_location = damage.location + 'new'
        post :update, params: { id: damage, damage: { location: new_location } }
        damage.reload
        expect(damage.location).to eq(new_location)
      end
      it 'redirects to the group page' do
        new_location = damage.location + 'new'
        post :update, params: { id: damage, damage: { location: new_location } }
        expect(response).to redirect_to damage
      end
    end

    context 'with invalid attributes' do
      it 'does not save the damage in the database' do
        old_location = damage.location
        post :update, params: { id: damage, damage: attributes_for(:invalid_damage) }
        damage.reload
        expect(damage.location).to eq(old_location)
      end
      it 're-renders the :edit template' do
        post :update, params: { id: damage, damage: attributes_for(:invalid_damage) }
        expect(response).to render_template :edit
      end
    end
  end
end
