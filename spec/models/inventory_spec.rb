require 'rails_helper'

RSpec.describe Inventory, type: :model do
  before :all do # this is only for the mocks!
    @uuid = "not real uuid"
  end

  context 'item types' do
    it 'returns an array of types' do
      array = Inventory.item_types
      expect(array).to be_a(Array)
    end

    it 'returns the one item given a uuid' do
      expect(response = Inventory.item_type(@uuid)).to be_a(Hash)
      expect(response["id"]).to eq(@uuid)
    end

    it 'updates item type' do
      expect(response = Inventory.update_item_type(@uuid, "some key", "some value")).not_to raise_error(InventoryError)
      expect(response).to be_a(Hash)
    end
    
    it 'deletes item type' do
      expect(Inventory.delete_item_type(@uuid)).not_to raise_errror(InventoryError)
    end
  end
end
