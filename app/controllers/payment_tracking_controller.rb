# frozen_string_literal: true
class PaymentTrackingController < ApplicationController
  after_action :set_return_url, only: [:index]

  def index
    params[:q] ||= {}

    # collect rentals with balance over or eq to
    min = (params.permit(:balance_gteq)[:balance_gteq] || -1).to_f # negative 1 is default because even paid rentals wont have negative balance
    search_area = rentals_visible_to_current_user.with_balance_over(min)

    search_q = params[:q].permit(:created_at_gteq, :created_at_lteq)
    # move these to end or beginning of day but only if they are present
    if search_q[:created_at_gteq].present?
      search_q[:created_at_gteq] =
        Date.parse(search_q[:created_at_gteq]).beginning_of_day
    end
    if search_q[:created_at_lteq].present?
      search_q[:created_at_lteq] =
        Date.parse(search_q[:created_at_lteq]).end_of_day
    end

    # collect rentals matching query
    @q = search_area.ransack(search_q)
    @rentals = @q.result
    gon.push(rentals: @rentals) # send to the js
  end

  # returns 204 by default and will not cause navigation in browser
  def send_invoice
    rental = Rental.find params.require(:rental_id)
    InvoiceMailer.send_invoice(rental).deliver_later if check_permission_for(rental) # async delivery
  end

  def send_many_invoices
    rentals = params.require :rentals
    errors = []
    rentals.each do |id|
      rental = Rental.find_by(id: id)
      if rental && check_permission_for(rental)
        InvoiceMailer.send_invoice(rental).deliver_later
      else
        errors.push id
      end
    end
    render json: { errors: errors }, status: (errors.any? ? 207 : 200)
  end

  private

  def check_permission_for(rental)
    @rentals ||= rentals_visible_to_current_user # will want to cache this
    @rentals.include? rental
  end
end
