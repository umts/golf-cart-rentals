class DigitalSignatureStringToInt < ActiveRecord::Migration
  def change
    remove_column :digital_signatures, :intent
    add_column :digital_signatures, :intent, :integer
  end
end
