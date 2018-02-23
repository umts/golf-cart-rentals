# frozen_string_literal: true
class FinancialTransactionsController < ApplicationController
  before_action :set_financial_transaction, only: [:show, :edit]

  after_action :set_return_url, only: [:index]

  # GET /financial_transactions
  def index
    @q = FinancialTransaction.search(params[:q])
    @trans_type = FinancialTransaction.all.pluck(:transactable_type).uniq
    @financial_transactions = @q.result.paginate(page: params[:page], per_page: 10)
  end

  # GET /financial_transactions/1
  def show; end

  def new
    @financial_transaction = FinancialTransaction.new
    @financial_transaction.rental = Rental.find(params.require(:rental_id))
    @financial_transaction.transactable_type = params[:transactable_type]

    # handles transactable_type payment which will be created with this form
    if @financial_transaction.transactable_type != Payment.name
      @financial_transaction.transactable_id = params[:transactable_id]
    end
  end

  # GET /financial_transactions/1/edit
  def edit; end

  # POST /financial_transactions
  def create
    @financial_transaction = FinancialTransaction.new(financial_transaction_params)
    if @financial_transaction.transactable_type == Payment.name
      payment = Payment.new(payment_params) # hard fail
      unless payment.save
        flash[:danger] = 'Failed to create Payment - please properly fill out Contact And Payment fields.'
        payment.errors.full_messages.each { |e| flash_message :warning, e, :now }
        render(:new) && return
      end
      @financial_transaction.transactable_id = payment.id
    end

    if @financial_transaction.save
      flash[:success] = 'Financial Transaction successfully created'
      redirect_to rental_invoice_path(@financial_transaction.rental_id)
    else
      flash[:danger] = 'Failed to create Financial Transaction'
      @financial_transaction.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_financial_transaction
    @financial_transaction = FinancialTransaction.find(params[:id])
  end

  def payment_params
    params.permit(:payment_type, :contact_name, :contact_email, :contact_phone, :reference)
  end

  # Only allow a trusted parameter "white list" through.
  def financial_transaction_params
    params.require(:financial_transaction).permit(:amount, :rental_id, :transactable_type, :transactable_id)
  end
end
