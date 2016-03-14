class HomeController < ApplicationController
  def index
    @rentals = Rental.where(user_id: @current_user.id)
    @rentals = @rentals.paginate(page: params[:page], per_page: 2)
  end
end
