class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :update_permission, :remove_permission, :remove_user]

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

  def edit
    @permissions = Permission.all
    @users = User.all
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      flash[:success] = 'Group Was Successfully Created'
      redirect_to @group
    else
      @group.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def update
    if @group.update(group_params)
      flash[:success] = 'Group Was Successfully Updated'
      redirect_to @group
    else
      @group.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:success] = 'Group Was Successfully Deleted'
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

  def remove_permission
    permission = Permission.find(params[:permission_id])
    @group.permissions.delete(permission)
    redirect_to edit_group_path(@group)
  end

  def remove_user
    @group.users.delete(params[:user_id])
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
