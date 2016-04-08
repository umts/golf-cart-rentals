require 'rails_helper'
include InventoryExceptions
# these tests must be run in order and all at once
RSpec.describe Inventory, order: :defined, type: :model do
  
  it 'item types' do
    uuid = nil
    name = ""
    response = nil
    until name.length > 120 do
      name += (rand(26) + 65).chr
    end
    
    #create
    expect { response = Inventory.create_item_type(name, ['fur type', 'height', 'cuddlyness']) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(uuid = response.try(:[],'uuid')).not_to be_nil
    
    # get all
    expect { response = Inventory.item_types }.not_to raise_error
    expect(response).to be_a(Array)
    expect(response.count).not_to eq 0
    
    # get one
    expect { response = Inventory.item_type(uuid) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[],'uuid')).to eq(uuid)
    expect(response.try(:[],'name')).to eq(name)

    # update it
    expect { response = Inventory.update_item_type(uuid, params = {allowed_keys: ['color']}) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[],'allowed_keys')).to eq(['color'])

    # delete it
    expect { response = Inventory.delete_item_type(uuid) }.not_to raise_error
    expect(response).to be_nil
    expect { Inventory.item_type(uuid) }.to raise_error ItemTypeNotFound

    @instance_var = 'some value that definatly is not nil'
  end

  it 'items' do
    # creates item
    response = nil
    expect { response = Inventory.create_item('billy', @uuid, {}) }.not_to raise_error
    expect(response).to be_a(Hash)

    # gets items by type
    response = nil
    expect { response = Inventory.items_by_type(@uuid) }.not_to raise_error
    expect(response).to be_a(Array)

    # get item by uuid
    response = nil
    expect { response = Inventory.item(@uuid) }.not_to raise_error
    expect(response).to be_a(Hash)

    # updates item
    response = nil
    expect { response = Inventory.update_item(@uuid, 'fur_color', 'brown') }.not_to raise_error
    expect(response).to be_a(Hash)

    # deletes item
    response = nil
    expect { response = Inventory.delete_item(@uuid) }.not_to raise_error
    expect(response).to be_nil
  end

  it 'reservations' do
    # creates reservation
    response = nil
    expect { response = Inventory.create_reservation(@uuid, Time.now, 6.days.from_now) }.not_to raise_error
    expect(response).to be_a(Hash)
    
    # get reservation
    response = nil
    expect { response = Inventory.reservation(@uuid) }.not_to raise_error
    expect(response).to be_a(Hash)

    # searches by time period
    response = nil
    expect { response = Inventory.reservations(Time.now, 6.days.from_now) }.not_to raise_error
    expect(response).to be_a(Array)

    #update reservation
    response = nil
    expect { response = Inventory.update_reservation(@uuid, 'key', 'value') }.not_to raise_error
    expect(response).to be_a(Hash)

    # updates reservation's metadata
    response = nil
    expect { response = Inventory.update_reservation_data('key', 'value') }.not_to raise_error
    expect(response).to be_nil

    # delete reservation
    response = nil
    expect { response = Inventory.delete_reservation(@uuid) }.not_to raise_error
    expect(response).to be_nil
  end

  it 'cleans up' do
    expect(@instance_var).not_to be_nill
  end
end
