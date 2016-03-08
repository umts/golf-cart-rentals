require 'rails_helper'

RSpec.describe Inventory, type: :model do
  before :all do # this is only for the mocks!
    @uuid = 'not a real uuid'
  end

  context 'item types' do
    it 'returns a array of types' do
      array = Inventory.item_types
      expect(array).to be_a(Array)
    end

    it 'returns the one item given a uuid' do
      expect(Inventory.item_type(@uuid)).to be_a(Hash)
    end
  end
end
