# frozen_string_literal: true
class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy, :remove_user]

  after_action :set_return_url, only: [:index, :show, :new, :edit]

  def index
    @departments = Department.all
  end

  def show; end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      flash[:success] = 'Department Successfully Created.'
      redirect_to @department
    else
      @department.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def edit; end

  def update
    if @department.update(department_params)
      flash[:success] = 'Department Successfully Updated.'
      redirect_to @department
    else
      flash[:warning] = 'Invalid Update Parameters'
      render :edit
    end
  end

  def remove_user
    @department.users.delete(params[:user_id])
    redirect_to edit_department_path(@department)
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name, user_ids: [])
  end
end
