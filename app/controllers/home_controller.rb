class HomeController < ApplicationController
  @per_page = 5

  def index
    @rentals = Rental.all
    @item_types = ItemType.all
    @upcoming_rentals = @rentals.where('end_time > ? AND rental_status = ?', DateTime.now, "reserved")
    @ongoing_rentals = @rentals.where('rental_status = ?', "checked_out")
    @no_show_rentals = @rentals.where('end_time <= ? AND rental_status = ?', DateTime.now, "reserved")
    @q = @rentals.where('rental_status = ?', "checked_in").search(params[:q])
    @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
    
    unless @current_user.groups.find_by(name: "admin").present?
      @upcoming_rentals = @upcoming_rentals.where('user_id = ?', @current_user.id)
      @ongoing_rentals = @ongoing_rentals.where('user_id = ?', @current_user.id)
      @no_show_rentals = @no_show_rentals.where('user_id = ?', @current_user.id)
      @q = @q.where('user_id = ?', @current_user.id).search(params[:q])
      @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
    end
  end
end
