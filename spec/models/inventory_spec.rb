require 'rails_helper'
include InventoryExceptions
# these tests must be run in order and all at once
RSpec.describe Inventory, order: :defined, type: :model do
  let(:name) {
    name = ""
    until name.length > 120 do
      name += (rand(26) + 65).chr
    end
    name
  }
  
  it 'tests the remote app' do
    response = nil
    
    item_type_uuid = nil
    # create item type
    expect { response = Inventory.create_item_type(name, ['fur type', 'height', 'cuddlyness']) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(item_type_uuid = response.try(:[],'uuid')).not_to be_nil
    
    # get all item type
    expect { response = Inventory.item_types }.not_to raise_error
    expect(response).to be_a(Array)
    expect(response.count).not_to eq 0
    
    # get one item type
    expect { response = Inventory.item_type(item_type_uuid) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[],'uuid')).to eq(item_type_uuid)
    expect(response.try(:[],'name')).to eq(name)

    # update item type
    expect { response = Inventory.update_item_type(item_type_uuid, params = {allowed_keys: ['color']}) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[],'allowed_keys')).to eq(['color'])

    item_uuid = nil
    # creates item
    expect { response = Inventory.create_item(item_type_uuid,name,true, {}) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect( item_uuid = response.try(:[],'uuid')).not_to be_nil
    
    # get item by uuid
    expect { response = Inventory.item(item_uuid) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[],'uuid')).to eq(item_uuid)

    # gets items by type
    expect { response = Inventory.items_by_type(item_type_uuid) }.not_to raise_error
    expect(response).to be_a(Array)
    expect(response).to include({'name' => name, 'uuid' => item_uuid})

    # updates item
    expect { response = Inventory.update_item(item_type_uuid, {}) }.not_to raise_error
    expect(response).to be_a(Hash)
    
    # creates reservation
    expect { response = Inventory.create_reservation(item_type_uuid, Time.now, 6.days.from_now) }.not_to raise_error
    expect(response).to be_a(Hash)
    
    # get reservation
    expect { response = Inventory.reservation(@uuid) }.not_to raise_error
    expect(response).to be_a(Hash)

    # searches by time period
    expect { response = Inventory.reservations(Time.now, 6.days.from_now) }.not_to raise_error
    expect(response).to be_a(Array)

    #update reservation
    expect { response = Inventory.update_reservation(@uuid, 'key', 'value') }.not_to raise_error
    expect(response).to be_a(Hash)

    # updates reservation's metadata
    expect { response = Inventory.update_reservation_data('key', 'value') }.not_to raise_error
    expect(response).to be_nil
    
    # delete item_type
    expect { response = Inventory.delete_item_type(item_type_uuid) }.not_to raise_error
    expect(response).to be_nil
    expect { Inventory.item_type(item_type_uuid) }.to raise_error ItemTypeNotFound

    # deletes item
    expect { response = Inventory.delete_item(item_uuid) }.not_to raise_error
    expect(response).to be_nil

    # delete reservation
    expect { response = Inventory.delete_reservation(@uuid) }.not_to raise_error
    expect(response).to be_nil
  end
end
