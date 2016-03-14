require 'rails_helper'
include InventoryExceptions

RSpec.describe Inventory, type: :model do
  before :all do # this is only for the mocks!
    @uuid = "not real uuid"
  end

  it 'can raise an exception' do
    expect { Inventory.mock_exception }.to raise_error(InventoryError)
  end

  context 'item types' do
    it 'returns an array of types' do
      response = nil
      expect { response = Inventory.item_types }.not_to raise_error
      expect(response).to be_a(Array)
    end

    it 'returns the one item given a uuid' do
      response = nil
      expect { response = Inventory.item_type(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response["id"]).to eq(@uuid)
    end

    it 'updates item type' do
      response = nil
      expect { response = Inventory.update_item_type(@uuid, "some key", "some value") }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    
    it 'deletes item type' do
      response = nil
      expect { response = Inventory.delete_item_type(@uuid) } .not_to raise_error
      expect(response).to be_nil 
    end

    it 'creates item type' do
      response = nil
      expect { response = Inventory.create_item_type("Alpaca", ["fur type","height","cuddlyness"]) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
  end

  context 'items' do
    it 'creates item' do
      response = nil
      expect { response = Inventory.create_item("billy", @uuid, {})}.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'gets items by type' do
      response = nil
      expect { response = Inventory.items_by_type(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'get item by uuid' do
      response = nil
      expect { response = Inventory.item(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'updates item' do
      response = nil
      expect { response = Inventory.update_item(@uuid, "fur_color", "brown") }.not_to raise_error
      expect(response).to be_a(Hash)
    end

    it 'deletes item' do
      response = nil
      expect { response = Inventory.delete_item(@uuid) }.not_to raise_error
      expect(response).to be_nil
    end
  end
end
