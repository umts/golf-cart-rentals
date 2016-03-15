require 'rails_helper'
include InventoryExceptions

RSpec.describe Inventory, order: :defined, type: :model do

  context 'item types' do
    it 'creates item type' do
      response = nil
      expect { response = Inventory.create_item_type('Alpaca', ['fur type', 'height', 'cuddlyness']) }.not_to raise_error
      expect(response).to be_a(Hash)
    end

    it 'returns an array of types' do # even if there are no item types then this will still return an array, an empty array but still an array!
      response = nil
      expect { response = Inventory.item_types }.not_to raise_error
      expect(response).to be_a(Array)
    end

    it 'returns the one item given a uuid' do
      response = nil
      expect { response = Inventory.item_type(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response['id']).to eq(@uuid)
    end

    it 'updates item type' do
      response = nil
      expect { response = Inventory.update_item_type(@uuid, 'some key', 'some value') }.not_to raise_error
      expect(response).to be_a(Hash)
    end

    it 'deletes item type' do
      response = nil
      expect { response = Inventory.delete_item_type(@uuid) } .not_to raise_error
      expect(response).to be_nil
    end
  end

  context 'items' do
    it 'creates item' do
      response = nil
      expect { response = Inventory.create_item('billy', @uuid, {}) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'gets items by type' do
      response = nil
      expect { response = Inventory.items_by_type(@uuid) }.not_to raise_error
      expect(response).to be_a(Array)
    end
    it 'get item by uuid' do
      response = nil
      expect { response = Inventory.item(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'updates item' do
      response = nil
      expect { response = Inventory.update_item(@uuid, 'fur_color', 'brown') }.not_to raise_error
      expect(response).to be_a(Hash)
    end

    it 'deletes item' do
      response = nil
      expect { response = Inventory.delete_item(@uuid) }.not_to raise_error
      expect(response).to be_nil
    end
  end

  context 'reservations' do
    it 'creates reservation' do
      response = nil
      expect { response = Inventory.create_reservation(@uuid, Time.now, 6.days.from_now) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'update reservation' do
      response = nil
      expect { response = Inventory.update_reservation(@uuid, 'key', 'value') }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'get reservation' do
      response = nil
      expect { response = Inventory.reservation(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'delete reservation' do
      response = nil
      expect { response = Inventory.delete_reservation(@uuid) }.not_to raise_error
      expect(response).to be_nil
    end
    it 'updates reservation\'s metadata' do
      response = nil
      expect { response = Inventory.update_reservation_data('key', 'value') }.not_to raise_error
      expect(response).to be_nil
    end
    it 'searches by time period' do
      response = nil
      expect { response = Inventory.reservations(Time.now, 6.days.from_now) }.not_to raise_error
      expect(response).to be_a(Array)
    end
  end
end