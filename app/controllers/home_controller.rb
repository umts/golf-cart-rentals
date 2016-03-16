class HomeController < ApplicationController
  def index
    @rentals = Rental.all
    @item_types = ItemType.all
    @upcoming_rentals = @rentals.where("user_id = ? AND end_date >= ?", @current_user.id, Time.zone.today)
    @q = @rentals.where("user_id = ? AND end_date < ?", @current_user.id, Time.zone.today).search(params[:q])
    @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: 5)
  end
end
