# frozen_string_literal: true
require 'will_paginate/array'
class PaymentTrackingController < ApplicationController

  def index
    # collect unpaid rentals
    @q = Rental.with_balance_due.ransack(params[:q])
    @rentals = @q.result.paginate(page: params[:page], per_page: 15)
  end

  # returns 204 by default and will not cause navigation in browser
  def send_invoice
    rental = Rental.find params.require(:rental_id)
    InvoiceMailer.send_invoice(rental).deliver_later # async delivery
  end

end
