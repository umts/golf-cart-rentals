# frozen_string_literal: true
class PaymentTrackingController < ApplicationController

  def index
    # collect unpaid rentals
    @rentals = Rental
  end

end
