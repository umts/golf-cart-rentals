require 'rails_helper'

RSpec.describe Department, type: :model do
  it 'has a valid factory' do
    expect(build(:department)).to be_valid
  end
  it 'is invalid without a name' do
    expect(build(:department, name: nil))
  end
  it 'does not allow duplicate name' do
    department = create(:department)
    expect(build(:department, name: department.name)).not_to be_valid
  end
end
