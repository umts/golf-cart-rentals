# frozen_string_literal: true
require 'rails_helper'

describe UsersController do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let :user_attributes do
    attributes_for(:user).merge(department_id: create(:department).id)
  end

  describe 'GET #index' do
    it 'populates an array of users' do
      get :index
      expect(assigns[:users]).to eq([user, user2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      get :show, params: { id: user }
      expect(assigns[:user]).to eq(user)
    end
    it 'renders the :show template' do
      get :show, params: { id: user }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new user to @user' do
      get :new
      expect(assigns[:user]).to be_a_new(User)
    end
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new user in the database' do
        expect do
          post :create, params: { user: user_attributes }
        end.to change(User, :count).by(1)
      end
      it 'redirects to the user page' do
        post :create, params: { user: user_attributes }
        expect(response).to redirect_to User.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new user in the database' do
        expect do
          post :create, params: { user: attributes_for(:invalid_user) }
        end.to_not change(User, :count)
      end
      it 're-renders the :new template' do
        post :create, params: { user: attributes_for(:invalid_user) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user to @user' do
      get :edit, params: { id: user }
      expect(assigns[:user]).to eq(user)
    end
    it 'renders the :edit template' do
      get :edit, params: { id: user }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the user in the database' do
        new_phone = '413-545-7257'
        post :update, params: { id: user, user: { phone: new_phone } }
        user.reload
        expect(user.phone).to eq(new_phone)
      end
      it 'redirects to the user page' do
        new_phone = '413-545-7257'
        post :update, params: { id: user, user: { phone: new_phone } }
        expect(response).to redirect_to user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the user in the database' do
        old_name = user.first_name
        post :update, params: { id: user, user: attributes_for(:invalid_user) }
        user.reload
        expect(user.first_name).to eq(old_name)
      end

      it 're-renders the :edit template' do
        post :update, params: { id: user, user: attributes_for(:invalid_user) }
        expect(response).to render_template :edit
      end

      context 'unpermited params' do
        it 'ignores the first_name and does what it can' do
          new_phone = '413-545-7257'
          expect do
            post :update, params: { id: user, user: { first_name: 'fidel castro', phone: new_phone } }
          end.not_to change(user, :first_name)
          expect(user.reload.phone).to eq(new_phone)
          expect(response).to redirect_to user
        end

        it 'ignores the last_name and does what it can' do
          new_phone = '413-545-7257'
          expect do
            post :update, params: { id: user, user: { last_name: 'fidel castro', phone: new_phone } }
          end.not_to change(user, :last_name)
          expect(user.reload.phone).to eq(new_phone)
          expect(response).to redirect_to user
        end

        it 'ignores the spire and does what it can' do
          new_phone = '413-545-7257'
          expect do
            post :update, params: { id: user, user: { spire_id: '12345678', phone: new_phone } }
          end.not_to change(user, :spire_id)
          expect(user.reload.phone).to eq(new_phone)
          expect(response).to redirect_to user
        end
      end
    end
  end

  describe 'POST #destroy' do
    it 'just disables the user' do
      expect do
        delete :destroy, params: { id: user }
      end.not_to change(User, :count)
      expect(user.reload.active).to be false
    end

    it 'redirects to the users index page' do
      delete :destroy, params: { id: user }
      expect(response).to redirect_to users_url
    end

    it 'denies permissions after inactive' do
      group = create(:group)
      permission = create(:permission, controller: 'user', action: 'show', id_field: nil)

      group.permissions << permission
      user.groups << group
      expect(user).to have_permission permission.controller, permission.action, nil
      delete :destroy, params: { id: user }
      expect(user.reload.active).to be false
      expect(user).not_to have_permission permission.controller, permission.action, nil
    end
  end

  describe 'POST #enable' do
    it 'deletes the user from the database' do
      user.active = false
      user.save
      expect do
        post :enable, params: { id: user }
      end.not_to change(User, :count)
      expect(user.reload.active).to be true
      expect(response).to redirect_to users_url
    end
  end
end
