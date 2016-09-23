class RenameTimesModifiedToAmount < ActiveRecord::Migration[5.0]
  def change
    rename_column :incurred_incidentals, :times_modified, :amount
  end
end
