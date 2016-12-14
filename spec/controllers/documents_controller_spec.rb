require 'rails_helper'

describe DocumentsController do
  let(:document) { create(:document) }

  describe '#show' do
    it 'retrieves the document' do
      get :show, params: { id: document.id }
      expect(assigns[:document]).to eq(document) 
    end
  end
end
