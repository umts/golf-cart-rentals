# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has a valid factory' do
    expect(build(:item)).to be_valid
  end
  it 'is invalid without a name' do
    expect(build(:item, name: '')).not_to be_valid
  end
  it 'is invalid without an item type' do
    expect(build(:item, item_type_id: nil)).not_to be_valid
  end

  describe 'class methods' do
    it 'correctly returns all reservable items' do
      expect(Item.all_reservable_items).to eq(Item.all)
    end
  end
end
