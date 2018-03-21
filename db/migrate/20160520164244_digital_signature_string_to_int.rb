class DigitalSignatureStringToInt < ActiveRecord::Migration[4.2]
  def change
    remove_column :digital_signatures, :intent
    add_column :digital_signatures, :intent, :integer
  end
end
