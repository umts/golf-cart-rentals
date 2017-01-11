# frozen_string_literal: true
class PaymentTrackingController < ApplicationController

  def index
    search_q = params[:q].permit(:days_since)


    # collect unpaid rentals matching query
    @q = Rental.with_balance_due.ransack(search_q)
    @rentals = @q.result
  end

  # returns 204 by default and will not cause navigation in browser
  def send_invoice
    rental = Rental.find params.require(:rental_id)
    InvoiceMailer.send_invoice(rental).deliver_later # async delivery
  end

end
