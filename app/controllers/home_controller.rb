class HomeController < ApplicationController
  @per_page = 5

  def index
    @rentals = Rental.all
    @item_types = ItemType.all
    @upcoming_rentals = @rentals.where('user_id = ? AND end_date >= ?', @current_user.id, Time.zone.today)
    @q = @rentals.where('user_id = ? AND end_date < ?', @current_user.id, Time.zone.today).search(params[:q])
    @past_rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end
end
