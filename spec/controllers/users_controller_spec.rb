require 'rails_helper'

describe UsersController do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }

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
      get :show, id: user
      expect(assigns[:user]).to eq(user)
    end
    it 'renders the :show template' do
      get :show, id: user
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
          post :create, user: attributes_for(:user)
        end.to change(User, :count).by(1)
      end
      it 'redirects to the user page' do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to User.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new user in the database' do
        expect do
          post :create, user: attributes_for(:invalid_user)
        end.to_not change(User, :count)
      end
      it 're-renders the :new template' do
        post :create, user: attributes_for(:invalid_user)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user to @user' do
      get :edit, id: user
      expect(assigns[:user]).to eq(user)
    end
    it 'renders the :edit template' do
      get :edit, id: user
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the user in the database' do
        new_name = user.first_name + 'new'
        post :update, id: user, user: { first_name: new_name }
        user.reload
        expect(user.first_name).to eq(new_name)
      end
      it 'redirects to the user page' do
        new_name = user.first_name + 'new'
        post :update, id: user, user: { first_name: new_name }
        expect(response).to redirect_to user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the user in the database' do
        old_name = user.first_name
        post :update, id: user, user: attributes_for(:invalid_user)
        user.reload
        expect(user.first_name).to eq(old_name)
      end
      it 're-renders the :edit template' do
        post :update, id: user, user: attributes_for(:invalid_user)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #destroy' do
    it 'deletes the user from the database' do
      expect do
        delete :destroy, id: user
      end.to change(User, :count).by(-1)
    end
    it 'redirects to the users index page' do
      delete :destroy, id: user
      expect(response).to redirect_to users_url
    end
  end
end
