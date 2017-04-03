# frozen_string_literal: true
class IncurredIncidentalsController < ApplicationController
  before_action :set_incurred_incidental, only: [:edit, :update, :show]
  before_action :set_incidental_types, only: [:new, :edit, :create, :update]
  before_action :set_rentals, only: [:new, :edit, :create, :update]

  def show
    @incurred_incidental = IncurredIncidental.find(params[:id])
  end

  def index
    @incurred_incidentals = IncurredIncidental.all
  end

  def new
    @incurred_incidental = IncurredIncidental.new
    @rental = Rental.find(params[:rental_id])
  end

  def create
    @incurred_incidental = IncurredIncidental.new(incidental_params)
    if @incurred_incidental.save
      flash[:success] = 'Incidental Successfully Created'
      if @incurred_incidental.incidental_type.damage_tracked
        flash[:warning] = 'Please Create Associated Damage Tracking'
        redirect_to new_damage_path(incurred_incidental_id: @incurred_incidental)
      else
        redirect_to incurred_incidental_path(@incurred_incidental)
      end
    else
      flash[:error] = 'Failed To Update Incidental'
      @incurred_incidental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def edit
    @rental = @incurred_incidental.rental
  end

  def update
    if @incurred_incidental.update(incidental_update_params)
      # find docs that just have an id, this means those were removed
      removables = incidental_update_params[:documents_attributes].select { |k,v|
        v.keys == ['id']
      }
      if removables.keys.any?
        # remove anything we find
        Document.destroy(removables.to_h.map { |k,v| v['id'] })
      end

      flash[:success] = 'Incidental Successfully Updated'
      redirect_to incurred_incidental_path(@incurred_incidental)
    else
      flash[:error] = 'Failed To Update Incidental'
      @incurred_incidental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      @rental = @incurred_incidental.rental
      render :edit
    end
  end

  private

  def set_incurred_incidental
    @incurred_incidental = IncurredIncidental.find(params[:id])
  end

  def set_incidental_types
    @incidental_types = IncidentalType.all
  end

  def set_rentals
    @rentals = Rental.all
  end

  def incidental_params
    incidental = params.require(:incurred_incidental).permit(:rental_id, :incidental_type_id, :amount, notes_attributes: [:note], documents_attributes: [:description, :uploaded_file])
    filter_empty_docs(incidental)
  end

  def incidental_update_params
    # we can allow id here for the notes
    incidental = params.require(:incurred_incidental).permit(:id, :rental_id, :incidental_type_id, :amount, notes_attributes: [:note], documents_attributes: [:description, :uploaded_file, :id])
    filter_empty_docs(incidental)
  end

  def filter_empty_docs(incidental)
    # documents attributes w/o description or an id do not exist yet
    # documents w/o description but has an idea exist, should fail to update
    incidental[:documents_attributes] = incidental[:documents_attributes].reject { |key,value|
      value[:description].blank? && value[:id].nil? # reject if blank desc and no id
    }
    incidental
  end
end
