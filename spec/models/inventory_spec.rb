require 'rails_helper'

RSpec.describe Inventory, type: :model do
  context 'item types' do
    it 'returns a array of types' do
      array = Inventory.item_types
      expect(array).to be_a(Array)
    end

    it 'returns the right item type' do
      #should there be some type of factory?
    end
  end
end
