class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

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

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    flash[:success] = 'Group Was Successfully Deleted'
    redirect_to groups_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :description, :user_ids => [], :permission_ids => [])
  end
end
