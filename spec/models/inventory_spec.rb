require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe '.method_missing' do
    it 'raises NoMethodError if client object does not define the method' do
      expect { described_class.is_trap? }.to raise_error(NoMethodError)
    end
  end
  describe '.respond_to?' do
    it 'returns false if client object does not define the method' do
      expect(described_class.respond_to?(:is_trap?)).to be(false)
    end
  end
end
