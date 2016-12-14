# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Document, type: :model do
  let(:document) { create(:document) } # creates document with png

  context 'validations' do
    it 'has a valid factory' do
      expect(build(:document)).to be_valid
    end
    
    it 'accepts a description' do
      expect(build(:document, description: 'a special document')).to be_valid
    end
  end

  context 'variable propogation' do
    it 'sets original_filename' do
      expect(document.original_filename).to be_present
    end

    it 'sets filename as the file on disk' do
      expect(document.filename).to be_present
    end

    context 'sets filetype' do
      it 'sets a filetype' do
        expect(document.filetype).to be_present
      end

      it 'sets picture' do
        expect(document).to be_picture # based on the fixture in spec/fixtures/file.png
      end

      it 'sets other' do
        expect(create(:document,:with_text_file)).to be_other # based on the fixture in spec/fixtures/file.txt
      end
    end
  end

  context 'refusing to write files' do
    it 'can refuse and throw exception' do
      expect{create(:document, :with_invalid_file)}.to raise_error
    end
  end

  context 'retreiving file' do
    it 'can retrieve file bytes' do
      expect(document.fetch_file.bytes).to be_present
    end

    it 'can retreive as base64' do
      expect(document.fetch_file_as_base64).to be_present
    end 
  end
end
