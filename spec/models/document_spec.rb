require 'rails_helper'

RSpec.describe Document, type: :model do
  it 'has a valid factory' do
    expect(build(:document)).to be_valid
  end
  it 'is invalid without a filename' do
    expect(build(:document, filename: nil)).not_to be_valid
  end

  describe '#file' do
    it 'returns a human readable string of the filepath' do
      d = create(:document)
      expect(d.file).to be_a(String)
    end
  end
end
