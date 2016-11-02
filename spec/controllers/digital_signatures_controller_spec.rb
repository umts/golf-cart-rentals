# frozen_string_literal: true
require 'rails_helper'
RSpec.describe DigitalSignaturesController, type: :controller do
  let(:ds) { create :digital_signature }

  describe 'GET #index' do
    it 'assigns all digital_signatures as @digital_signatures' do
      sigs = create_list :digital_signature, 10
      get :index
      expect(assigns(:digital_signatures)).to eq(sigs)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested digital_signature as @digital_signature' do
      get :show, params: { id: ds.to_param }
      expect(assigns(:digital_signature)).to eq(ds)
    end
  end
end
