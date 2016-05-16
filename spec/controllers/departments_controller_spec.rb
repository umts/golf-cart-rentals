require 'rails_helper'

describe DepartmentsController do
  let!(:department) { create(:department) }
  let!(:department2) { create(:department) }

  describe 'GET #index' do
    it 'populates an array of departments' do
      get :index
      expect(assigns[:departments]).to eq([department, department2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested department do @department' do
      get :show, id: department
      expect(assigns[:department]).to eq(department)
    end
    it 'renders the :show template' do
      get :show, id: department
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new department to @department' do
      get :new
      expect(assigns[:department]).to be_a_new(Department)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new department in the databse' do
        expect do
          post :create, department: attributes_for(:department)
        end.to change(Department, :count).by(1)
      end

      it 'redirects to the department page' do
        post :create, department: attributes_for(:department)
        expect(response).to redirect_to Department.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new department in the database' do
        expect do
          post :create, department: attributes_for(:invalid_department)
        end.to_not change(Department, :count)
      end
      it 're-renders the :new template' do
        post :create, department: attributes_for(:invalid_department)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested department to @department' do
      get :edit, id: department
      expect(assigns[:department]).to eq(department)
    end
    it 'renders the :edit template' do
      get :edit, id: department
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the department in the database' do
        new_name = department.name + 'new'
        post :update, id: department, department: { name: new_name }
        department.reload
        expect(department.name).to eq(new_name)
      end
      it 'redirects to the group page' do
        new_name = department.name + 'new'
        post :update, id: department, department: { name: new_name }
        expect(response).to redirect_to department
      end
    end

    context 'with invalid attributes' do
      it 'does not save the department in the database' do
        old_name = department.name
        post :update, id: department, department: attributes_for(:invalid_department)
        department.reload
        expect(department.name).to eq(old_name)
      end
      it 're-renders the :edit template' do
        post :update, id: department, department: attributes_for(:invalid_department)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #remove_user' do
    it 'removes the user from the department' do
      old_user = create(:user)
      department.users << old_user

      post :remove_user, id: department, user_id: old_user

      department.reload
      expect(department.users).not_to include(old_user)
      expect(response).to redirect_to edit_department_url(department)
    end
  end
end
