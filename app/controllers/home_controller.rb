# frozen_string_literal: true
class HomeController < ApplicationController
  @per_page = 5

  def index
    @rentals = if @current_user.groups.where(name: 'admin').present?
                 Rental.all
               else
                 Rental.rented_by @current_user
               end
    @item_types = ItemType.all
    categorize_rentals
  end

  private

  def categorize_rentals
    @upcoming_rentals = @rentals.upcoming_rentals
    @ongoing_rentals = @rentals.picked_up
    @no_show_rentals = @rentals.no_show_rentals
    @future_rentals = @rentals.all_future_rentals
    @q = Rental.inactive_rentals.search(params[:q])
    @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end
end
