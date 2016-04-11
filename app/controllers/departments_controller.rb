class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy, :remove_user]

  def index
    @departments = Department.all
  end

  def show
  end

  def new
    @department = Department.new
    @users = User.all
  end

  def edit

  end

  def create
    @department = Department.new(department_params)

    if @department.save
      flash[:success] = 'Department was successfully created.'
      redirect_to @department
    else
      @department.errors.full_messages.each { |e| flash_message :warning, e, :now }
      @users = User.all
      render :new
    end
  end

  private
  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name, user_ids: [])
  end

end
