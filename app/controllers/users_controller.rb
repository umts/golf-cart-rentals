class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'User Was Successfully Created'
      redirect_to @user
    else
      @user.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'User Was Successfully Updated'
      redirect_to @user
    else
      @user.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'User Was Successfully Deleted'
    redirect_to users_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email, :spire_id)
  end
end
