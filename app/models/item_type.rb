# frozen_string_literal: true
class ItemType < ActiveRecord::Base
  validates :name, :base_fee, :fee_per_day, presence: true
  validates :base_fee, :fee_per_day, numericality: { greater_than_or_equal_to: 0 }

  has_many :item

  def cost(start_time, end_time)
    return 0 if start_time > end_time

    # have to add one day at the end 12th to 13th is 2 days, pick up on 12 drop of on 13 is two full days
    rental_duration = (end_time.to_date - start_time.to_date).to_i + 1
    no_of_weeks = (rental_duration / 7)
    # Do not charge for 1/7 days in a rental.
    days_to_charge_for = rental_duration - no_of_weeks
    # Long term pricing
    longterm_prices = longterm_cost(no_of_weeks)

    unless longterm_prices.nil? # catch cases where item is neither 4 nor 6 seat cart
      return longterm_prices[no_of_weeks] + ((rental_duration % 7) * fee_per_day)
    end
    (days_to_charge_for * fee_per_day) + base_fee
  end

  # returns the number of reservable items of this item_type
  def available_items_count
    self.item.select { |i| Inventory.item(i.uuid)[:reservable] }.size
  end

  private

  def longterm_cost(weeks)
    # prices are specially defined
    if weeks >= 2
      if name == '4 Seat'
        { 2 => 500, 3 => 700, 4 => 850 }
      elsif name == '6 Seat'
        { 2 => 600, 3 => 900, 4 => 1100 }
      end
    end
  end
end
