# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Permission, type: :model do
  it 'has a valid factory' do
    expect(build(:permission)).to be_valid
  end
  it 'is invalid without a controller' do
    expect(build(:permission, controller: nil)).not_to be_valid
  end
  it 'is invalid without an action' do
    expect(build(:permission, action: nil)).not_to be_valid
  end

  describe '#name' do
    it 'returns a human readable string of the permission' do
      p = create(:permission)
      expect(p.name).to be_a(String)
    end
  end

  describe '#model' do
    it 'returns a reference to the model class that this permission references' do
      p = create(:permission, controller: 'users')
      expect(p.model).to eq(User)
    end

    it 'returns the nil if the permission does not link to a model' do
      p = create :permission, controller: 'fake'
      expect(p.model).to be_nil
    end
  end

  describe '.update_permissions_table' do
    it 'adds new controller actions to the permissions table' do
      Permission.update_permissions_table
      expect(Permission.find_by(controller: 'test')).to be_nil

      class TestController < ApplicationController
        def index; end
      end

      Permission.update_permissions_table
      expect(Permission.find_by(controller: 'test', action: 'index')).to be_a(Permission)
    end

    it 'deletes permissions with non-existant controllers' do
      p = create(:permission)
      expect(Permission.find_by(controller: p.controller, action: p.action)).to be_a(Permission)

      Permission.update_permissions_table
      expect(Permission.find_by(controller: p.controller, action: p.action)).to be_nil
    end

    it 'deletes permissions with non-existant actions' do
      Permission.update_permissions_table
      p = create(:permission, controller: Permission.all.first.controller, action: 'dummy_action')
      expect(Permission.find_by(controller: p.controller, action: p.action)).to be_a(Permission)

      Permission.update_permissions_table
      expect(Permission.find_by(controller: p.controller, action: p.action)).to be_nil
    end
  end
end
