class RemoveDigitalSignatures < ActiveRecord::Migration[5.0]
  def change
    # no need to save it, never made it to prod
    drop_table :digital_signatures
  end
end
