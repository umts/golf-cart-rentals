# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Note, type: :model do
  context 'does not build with invalid params' do
    it 'requires a note' do
      expect(build(:note, note: nil)).not_to be_valid
    end
  end

  context 'properly builds association with incurred_incidental' do
    before(:each) do
      @incident = create(:incurred_incidental)
      @incident.notes << create(:note)
      @note = Note.first
    end

    it 'is noteable' do
      expect(@note.noteable).to eq @incident
    end

    it 'is accessible in incurred_incidental' do
      expect(@incident.notes.include? @note).to eq true
    end
  end
end
