# frozen_string_literal: true
class FinancialTransactionsController < ApplicationController
  def index
    # workaround for unknown Ransack bug
    @q = FinancialTransaction.search(transactable_type_eq: params[:q].try(:[], :transactable_type))
    @trans_type = FinancialTransaction.all.pluck(:transactable_type).uniq
    @financial_transactions = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @financial_transaction = FinancialTransaction.new
    @financial_transaction.rental = Rental.find(params.require(:rental_id))
    @financial_transaction.transactable_type = params[:transactable_type]

    # handles transactable_type payment which will be created with this form
    if @financial_transaction.transactable_type != Payment.name
      @financial_transaction.transactable_id = params[:transactable_id]
    end
  end

  def create
    @financial_transaction = FinancialTransaction.new(financial_transaction_params)
    if @financial_transaction.transactable_type == Payment.name
      payment = Payment.new(payment_params)
      unless payment.save
        flash[:danger] = payment.errors.full_messages
        render :new and return
      end
      @financial_transaction.transactable_id = payment.id
    end

    if @financial_transaction.save
      flash[:success] = 'Financial Transaction successfully created'
      redirect_to rental_invoice_path(@financial_transaction.rental_id)
    else
      flash[:danger] = @financial_transaction.errors.full_messages
      render :new
    end
  end

  private

  def financial_transaction_params
    params.require(:financial_transaction).permit(:amount, :rental_id,
                                                  :transactable_type, :transactable_id)
  end

  def payment_params
    params.permit(:payment_type, :contact_name, :contact_email, :contact_phone, :reference)
  end
end
