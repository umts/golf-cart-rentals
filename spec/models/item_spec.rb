require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has a valid factory' do
    expect(build(:item)).to be_valid
  end
  it 'is invalid without a name' do
    expect(build(:item, name: "")).not_to be_valid
  end
  it 'is invalid without an item type' do
    expect(build(:item, item_type_id: nil)).not_to be_valid
  end

  describe 'class methods' do
    it 'correctly returns all reservable items' do
      expect(Item.all_reservable_items).to eq(Item.all)
    end
  end

  describe '.deleted' do
    it 'returns an empty collection when no records are present' do
      expect(Item.deleted).to be_empty
    end

    it 'returns an empty collection, when no deleted items exist' do
      create(:item)
      expect(Item.deleted).to be_empty
    end

    it 'returns a collection with records when one deleted item exists' do
      item = create(:item) and item.destroy
      expect(Item.deleted).to include(item)
    end

    it 'returns the correct records, when many records exist' do
      item = create(:item) and item.destroy
      item_two = create(:item)
      expect(Item.deleted).to contain_exactly(item)
    end
  end
end
