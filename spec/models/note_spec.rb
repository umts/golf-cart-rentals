require 'rails_helper'

RSpec.describe Note, type: :model do
  context 'does not build with invalid params' do
    it 'requires a note' do
      expect(build(:note, note: nil)).not_to be_valid
    end
  end

  context 'properly builds association with note' do
    it 'is noteable' do
      @incident = create(:incurred_incidental)
      @incident.notes << create(:note)
      @note = Note.first

      expect(@incident.notes.first).to eq @note
      expect(@note.noteable).to eq @incident
    end
  end
end
