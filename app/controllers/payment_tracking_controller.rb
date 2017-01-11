# frozen_string_literal: true
class PaymentTrackingController < ApplicationController

  def index
    params[:q] ||= {}

    search_q = params[:q].permit(:days_since)
    # move these to end or beginning of day but only if they are present
    search_q[:created_at_gteq] =
      Date.parse(search_q[:created_at_gteq]).beginning_of_day if search_q[:created_at_gteq].present?
    search_q[:created_at_lteq] =
      Date.parse(search_q[:created_at_lteq]).end_of_day if search_q[:created_at_lteq].present?

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
