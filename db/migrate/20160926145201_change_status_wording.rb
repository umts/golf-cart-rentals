class ChangeStatusWording < ActiveRecord::Migration[5.0]
  def change
    rename_column :rentals, :checked_in_at, :dropped_off_at
    rename_column :rentals, :checked_out_at, :picked_up_at
  end
end
