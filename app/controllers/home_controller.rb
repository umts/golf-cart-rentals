class HomeController < ApplicationController
  @per_page = 5

  def index
    @rentals = Rental.all
    @item_types = ItemType.all
    categorize_rentals
    non_admin_filter unless @current_user.groups.find_by(name: 'admin').present?
  end

  private

  def categorize_rentals
    @upcoming_rentals = @rentals.where('end_time > ? AND rental_status = ?', DateTime.current, 'reserved')
    @ongoing_rentals = @rentals.where('rental_status = ?', 'checked_out')
    @no_show_rentals = @rentals.where('end_time <= ? AND rental_status = ?', DateTime.current, 'reserved')
    @q = @rentals.where('rental_status = ?', 'checked_in').search(params[:q])
    @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end

  def non_admin_filter
    @upcoming_rentals = @upcoming_rentals.where('user_id = ?', @current_user.id)
    @ongoing_rentals = @ongoing_rentals.where('user_id = ?', @current_user.id)
    @no_show_rentals = @no_show_rentals.where('user_id = ?', @current_user.id)
    @q = @q.where('user_id = ?', @current_user.id).search(params[:q])
    @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end
end
