# frozen_string_literal: true
class FinancialTransactionsController < ApplicationController
  before_action :set_financial_transaction, only: [:show, :edit]

  after_action :set_return_url, only: [:index]

  def show
  end

  def index
    @q = FinancialTransaction.search(params[:q])
    @trans_type = FinancialTransaction.all.pluck(:transactable_type).uniq
    @financial_transactions = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @financial_transaction = FinancialTransaction.new
    @financial_transaction.rental = Rental.find(params.require(:rental_id))
    @financial_transaction.transactable_type = params[:transactable_type]

    # handles transactable_type payment which will be created with this form
    @financial_transaction.transactable_id = params[:transactable_id] if @financial_transaction.transactable_type != Payment.name
  end

  def create
    @financial_transaction = FinancialTransaction.new(financial_transaction_params)
    if @financial_transaction.transactable_type == Payment.name
      payment = Payment.new(payment_params) # hard fail
      unless payment.save
        flash[:danger] = 'Please Properly Fill Out Contact And Payment Fields'
        render(:new) && return
      end
      @financial_transaction.transactable_id = payment.id
    end

    if @financial_transaction.save
      redirect_to rental_invoice_path(@financial_transaction.rental_id), success: 'Financial Transaction Successfully Created'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  private

  def set_financial_transaction
    @financial_transaction = FinancialTransaction.find(params[:id])
  end

  def financial_transaction_params
    params.require(:financial_transaction).permit(:amount, :rental_id, :transactable_type, :transactable_id)
  end

  def payment_params
    params.permit(:payment_type, :contact_name, :contact_email, :contact_phone, :reference)
  end
end
