# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :enable]
  before_action :set_department

  after_action :set_return_url, only: [:index]

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'User successfully created'
      flash[:warning] = 'User has no Permissions'

      redirect_to @user
    else
      flash[:danger] = 'Failed to create user'
      flash[:warning] = @user.errors.full_messages
      render :new
    end
  end

  def update
    if @user.update(update_user_params)
      flash[:success] = 'User successfully updated'
      redirect_to @user
    else
      flash[:danger] = 'Failed to update User'
      flash[:warning] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user.update(active: false)
    flash[:success] = 'User successfully disabled'
    redirect_to users_url
  end

  def enable
    @user.update(active: true)
    flash[:success] = 'User successfully enabled'
    redirect_to users_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_department
    @departments = Department.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email, :spire_id, :department_id)
  end

  def update_user_params
    params.require(:user).permit(:phone, :email, :department_id)
  end
end
