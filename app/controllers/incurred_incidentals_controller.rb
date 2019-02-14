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
    @incurred_incidental.financial_transaction = FinancialTransaction.new
    @rental = Rental.find(params[:rental_id])
  end

  def create
    @incurred_incidental = IncurredIncidental.new(incidental_params)
    if @incurred_incidental.save
      flash[:success] = 'Incidental successfully created'
      if @incurred_incidental.incidental_type.damage_tracked
        flash[:warning] = 'Please fill out additional Damage tracking form'
        redirect_to new_damage_path(incurred_incidental_id: @incurred_incidental)
      else
        redirect_to incurred_incidental_path(@incurred_incidental)
      end
    else
      flash[:danger] = @incurred_incidental.errors.full_messages
      redirect_to new_incurred_incidental_path(rental_id: @incurred_incidental.rental)
    end
  end

  def edit
    @rental = @incurred_incidental.rental
    @financial_transaction = @incurred_incidental.financial_transaction
  end

  def update
    update_params = incidental_update_params
    if @incurred_incidental.update(update_params)
      # find docs that just have an id, this means those were removed
      if update_params[:documents_attributes]
        removables = update_params[:documents_attributes].select do |_k, v|
          v.keys == ['id']
        end
        if removables.keys.any?
          # remove anything we find
          Document.destroy(removables.to_h.map { |_k, v| v['id'] })
        end
      end

      flash[:success] = 'Incidental successfully updated'
      redirect_to incurred_incidental_path(@incurred_incidental)
    else
      flash[:danger] = @incurred_incidental.errors.full_messages
      @rental = @incurred_incidental.rental
      redirect_to edit_incurred_incidental_path
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
    incidental = params.require(:incurred_incidental)
                       .permit(:rental_id, :incidental_type_id, :item_id, :amount,
                               notes_attributes: [:note],
                               documents_attributes: [:description, :uploaded_file],
                               financial_transaction_attributes: [:amount, :id])

    if incidental[:financial_transaction_attributes].present?
      incidental[:financial_transaction_attributes][:rental_id] = incidental[:rental_id]
    end
    filter_empty_docs(incidental)
  end

  def incidental_update_params
    # we can allow id here for the notes
    incidental = params.require(:incurred_incidental)
                       .permit(:id, :rental_id, :incidental_type_id, :item_id, :amount,
                               notes_attributes: [:note],
                               documents_attributes: [:description, :uploaded_file, :id],
                               financial_transaction_attributes: [:amount, :id])
    if incidental[:financial_transaction_attributes]
      incidental[:financial_transaction_attributes][:rental_id] = @incurred_incidental.rental_id
    end
    filter_empty_docs(incidental)
  end

  def filter_empty_docs(incidental)
    # documents attributes w/o description and w/o id do not exist yet and are a user upload error
    # documents w/o description but has an id exist, will be deleted latter
    if incidental[:documents_attributes]
      incidental[:documents_attributes] = incidental[:documents_attributes].reject do |_key, value|
        value[:description].blank? && value[:id].nil? # reject if blank desc and no id
      end
    end
    incidental
  end
end
