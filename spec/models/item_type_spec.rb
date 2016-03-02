require 'rails_helper'

RSpec.describe ItemType, type: :model do
  it 'has valid factory' do
    expect(build(:item_type)).to be_valid
  end
end
