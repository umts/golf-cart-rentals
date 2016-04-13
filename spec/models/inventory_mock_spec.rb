require 'rails_helper'
include InventoryExceptions

RSpec.describe InventoryMock, type: :model do
  before :all do # this is only for the mocks!
    @uuid = 'not real uuid'
  end

  it 'can raise an exception' do
    expect { InventoryMock.mock_exception }.to raise_error(InventoryError)
  end

  context 'item types' do
    it 'returns an array of types' do
      response = nil
      expect { response = InventoryMock.item_types }.not_to raise_error
      expect(response).to be_a(Array)
    end

    it 'returns the one item given a uuid' do
      response = nil
      expect { response = InventoryMock.item_type(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
      expect(response['id']).to eq(@uuid)
    end

    it 'updates item type' do
      response = nil
      expect { response = InventoryMock.update_item_type(@uuid, 'some key', 'some value') }.not_to raise_error
      expect(response).to be_a(Hash)
    end

    it 'deletes item type' do
      response = nil
      expect { response = InventoryMock.delete_item_type(@uuid) } .not_to raise_error
      expect(response).to be_nil
    end

    it 'creates item type' do
      response = nil
      expect { response = InventoryMock.create_item_type('Alpaca', ['fur type', 'height', 'cuddlyness']) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
  end

  context 'items' do
    it 'creates item' do
      response = nil
      expect { response = InventoryMock.create_item('billy', @uuid, {}) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'gets items by type' do
      response = nil
      expect { response = InventoryMock.items_by_type(@uuid) }.not_to raise_error
      expect(response).to be_a(Array)
    end
    it 'get item by uuid' do
      response = nil
      expect { response = InventoryMock.item(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'updates item' do
      response = nil
      expect { response = InventoryMock.update_item(@uuid, 'fur_color', 'brown') }.not_to raise_error
      expect(response).to be_a(Hash)
    end

    it 'deletes item' do
      response = nil
      expect { response = InventoryMock.delete_item(@uuid) }.not_to raise_error
      expect(response).to be_nil
    end
  end

  context 'reservations' do
    it 'creates reservation' do
      response = nil
      expect { response = InventoryMock.create_reservation(@uuid, Time.now.iso8601, 6.days.from_now) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'update reservation' do
      response = nil
      expect { response = InventoryMock.update_reservation(@uuid, 'key', 'value') }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'get reservation' do
      response = nil
      expect { response = InventoryMock.reservation(@uuid) }.not_to raise_error
      expect(response).to be_a(Hash)
    end
    it 'delete reservation' do
      response = nil
      expect { response = InventoryMock.delete_reservation(@uuid) }.not_to raise_error
      expect(response).to be_nil
    end
    it 'updates reservation\'s metadata' do
      response = nil
      expect { response = InventoryMock.update_reservation_data('key', 'value') }.not_to raise_error
      expect(response).to be_nil
    end
    it 'searches by time period' do
      response = nil
      expect { response = InventoryMock.reservations(Time.now.iso8601, 6.days.from_now) }.not_to raise_error
      expect(response).to be_a(Array)
    end
  end
end
