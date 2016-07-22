class HomeController < ApplicationController
  @per_page = 5

  def index
    @rentals = Rental.all
    @item_types = ItemType.all
    categorize_rentals
  end

  private

  def categorize_rentals
    @upcoming_rentals = Rental.upcoming_rentals
    @ongoing_rentals = Rental.checked_out
    @no_show_rentals = Rental.no_show_rentals
    @future_rentals = Rental.all_future_rentals
    @q = Rental.checked_in.search(params[:q])
    @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end

  #Not necessary now, but could be useful when non-admins use the site
  def non_admin_filter
    @upcoming_rentals = @upcoming_rentals.users_rentals(@current_user.id)
    @ongoing_rentals = @ongoing_rentals.users_rentals(@current_user.id)
    @no_show_rentals = @no_show_rentals.users_rentals(@current_user.id)
    @q = @q.users_rentals(@current_user.id).search(params[:q])
    @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end
end
