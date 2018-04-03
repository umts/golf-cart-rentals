# frozen_string_literal: true
class GroupsController < ApplicationController
  before_action :set_group, except: [:index, :new, :create]
 
  after_action :set_return_url, only: [:index]

  def index
    @groups = Group.all
  end

  def show
  end

  def new
    @group = Group.new
    @permissions = Permission.all
    @users = User.all
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      flash[:success] = 'Group successfully created'
      redirect_to @group
    else
      flash[:danger] = 'Failed to create Group'
      flash[:warning] = @group.errors.full_messages
      render :new
    end
  end

  def edit
    @permissions = Permission.all
    @users = User.all
  end

  def update
    if @group.update(group_params)
      flash[:success] = 'Group successfully updated'
      redirect_to @group
    else
      flash[:danger] = 'Failed to update Group'
      flash[:warning] = @group.errors.full_messages
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:success] = 'Group successfully deleted'
    redirect_to groups_url
  end

  def update_permission
    # remove the outdated permission
    old_permission = @group.permissions.where(
      controller: old_permission_params[:controller],
      action: old_permission_params[:action],
      id_field: old_permission_params[:old_id_field]
    )
    @group.permissions.delete(old_permission)
    # find or create the new permission
    permission = Permission.find_or_create_by(permission_params)
    @group.permissions << permission if @group.permissions.exclude? permission
    redirect_to edit_group_path(@group)
  end

  # mark inactive
  def remove_permission
    permission = @group.permissions.find params[:permission_id]
    permission.update(active: false)
    redirect_to edit_group_path(@group)
  end

  def enable_permission
    permission = @group.permissions.find params[:permission_id]
    permission.update(active: true)
    redirect_to edit_group_path(@group)
  end

  # mark inactive
  def remove_user
    user = @group.groups_users.find_by user_id: params[:user_id]
    user.update(active: false)
    redirect_to edit_group_path(@group)
  end

  def enable_user
    user = @group.groups_users.find_by user_id: params[:user_id]
    user.update(active: true)
    redirect_to edit_group_path(@group)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :description, user_ids: [], permission_ids: [])
  end

  def old_permission_params
    params.require(:permission).permit(:controller, :action, :old_id_field).delete_if { |_k, v| v.blank? }
  end

  def permission_params
    params.require(:permission).permit(:controller, :action, :id_field).delete_if { |_k, v| v.blank? }
  end
end
