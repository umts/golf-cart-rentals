require 'rails_helper'

describe GroupsController do
  let!(:group) { create(:group) }
  let!(:group2) { create(:group) }

  describe 'GET #index' do
    it 'populates an array of groups' do
      get :index
      expect(assigns[:groups]).to eq([group, group2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested group to @group' do
      get :show, id: group
      expect(assigns[:group]).to eq(group)
    end
    it 'renders the :show template' do
      get :show, id: group
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new group to @group' do
      get :new
      expect(assigns[:group]).to be_a_new(Group)
    end
    it 'assigns all the permissions to @permissions' do
      get :index
      expect(assigns[:groups]).to eq([group, group2])
    end
    it 'assigns all the users to @users' do
      get :index
      expect(assigns[:groups]).to eq([group, group2])
    end
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new group in the database' do
        expect do
          post :create, group: attributes_for(:group)
        end.to change(Group, :count).by(1)
      end
      it 'attaches the group to users and permissions' do
        attributes = attributes_for(:group_with_users_and_permissions)
        post :create, group: attributes
        expect(Group.last.users.to_ary).to eq(attributes[:user_ids])
        expect(Group.last.permissions.to_ary).to eq(attributes[:permission_ids])
      end
      it 'redirects to the group page' do
        post :create, group: attributes_for(:group)
        expect(response).to redirect_to Group.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new contact in the database' do
        expect do
          post :create, group: attributes_for(:invalid_group)
        end.to_not change(Group, :count)
      end
      it 're-renders the :new template' do
        post :create, group: attributes_for(:invalid_group)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested group to @group' do
      get :edit, id: group
      expect(assigns[:group]).to eq(group)
    end
    it 'assigns all the permissions to @permissions' do
      get :index
      expect(assigns[:groups]).to eq([group, group2])
    end
    it 'assigns all the users to @users' do
      get :index
      expect(assigns[:groups]).to eq([group, group2])
    end
    it 'renders the :edit template' do
      get :edit, id: group
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the group in the database' do
        new_name = group.name + 'new'
        post :update, id: group, group: { name: new_name }
        group.reload
        expect(group.name).to eq(new_name)
      end
      it 'updates the groups attached users and permissions' do
        attributes = attributes_for(:group_with_users_and_permissions)
        post :create, group: attributes
        expect(Group.last.users.to_ary).to eq(attributes[:user_ids])
        expect(Group.last.permissions.to_ary).to eq(attributes[:permission_ids])
      end
      it 'redirects to the group page' do
        new_name = group.name + 'new'
        post :update, id: group, group: { name: new_name }
        expect(response).to redirect_to group
      end
    end

    context 'with invalid attributes' do
      it 'does not save the contact in the database' do
        old_name = group.name
        post :update, id: group, group: attributes_for(:invalid_group)
        group.reload
        expect(group.name).to eq(old_name)
      end
      it 're-renders the :edit template' do
        post :update, id: group, group: attributes_for(:invalid_group)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #destroy' do
    it 'deletes the group from the database' do
      expect do
        delete :destroy, id: group
      end.to change(Group, :count).by(-1)
    end
    it 'redirects to the groups index page' do
      delete :destroy, id: group
      expect(response).to redirect_to groups_url
    end
  end

  describe 'POST #update_permission' do
    it 'removes the old permission and appends the new permission to the group' do
      old_permission = create(:permission)
      group.permissions << old_permission

      new_permission = create(:permission, controller: old_permission.controller, action: old_permission.action, id_field: "#{old_permission.id_field}new")
      new_attributes = new_permission.attributes
      new_attributes[:old_id_field] = old_permission.id_field

      post :update_permission, id: group, permission: new_attributes

      group.reload
      expect(group.permissions).not_to include(old_permission)
      expect(group.permissions).to include(new_permission)
      expect(response).to redirect_to edit_group_url(group)
    end
  end

  describe 'POST #remove_permission' do
    it 'removes the permission from the group' do
      old_permission = create(:permission)
      group.permissions << old_permission

      post :remove_permission, id: group, permission_id: old_permission

      group.reload
      expect(group.permissions).not_to include(old_permission)
      expect(response).to redirect_to edit_group_url(group)
    end
  end

  describe 'POST #remove_user' do
    it 'removes the user from the group' do
      old_user = create(:user)
      group.users << old_user

      post :remove_user, id: group, user_id: old_user

      group.reload
      expect(group.users).not_to include(old_user)
      expect(response).to redirect_to edit_group_url(group)
    end
  end
end
