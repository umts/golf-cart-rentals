# frozen_string_literal: true
require 'rails_helper'

describe User do
  let(:user) { create :user }

  context 'validations' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
    it 'is invalid without a first_name' do
      expect(build(:user, first_name: nil)).not_to be_valid
    end
    it 'is invalid without a last_name' do
      expect(build(:user, last_name: nil)).not_to be_valid
    end
    it 'is invalid without an email' do
      expect(build(:user, email: nil)).not_to be_valid
    end
    it 'is invalid without a phone' do
      expect(build(:user, phone: nil)).not_to be_valid
    end
    it 'is invalid without a spire_id' do
      expect(build(:user, spire_id: nil)).not_to be_valid
    end
    it 'does not allow duplicate spire_ids' do
      user = create(:user)
      expect(build(:user, spire_id: user.spire_id)).not_to be_valid
    end

    it 'requires spire id to be length 8' do
      expect(build(:user, spire_id: '1234567')).not_to be_valid
    end
  end

  context 'helper methods' do
    context 'assignable users' do
      before do
        User.destroy_all
        @dept_one = create :department
        @dept_one_users = create_list :user, 10, department: @dept_one
        @other_users = create_list :user, 10 # not in @dept_one
      end

      it 'returns all users if they have the permission' do
        u = @other_users.first
        g = create(:group)
        g.permissions << create(:permission, controller: 'rentals', action: 'assign_anyone')
        g.save
        u.groups << g
        u.save
        expect(u.assignable_renters).to match_array User.all.to_a # everyone
      end

      it 'returns just the users in the department by default' do
        u = @other_users.first
        expect(u.assignable_renters).to match_array u.department.users.to_a # department mates
      end
    end

    it 'builds a tag' do
      expect(user.tag).to include user.spire_id, user.full_name
    end

    describe '#full_name' do
      it 'returns first name and last name with a space in between' do
        expect(user.full_name).to eql "#{user.first_name} #{user.last_name}"
      end
    end
  end

  describe '#has_permission?' do
    let(:permission) { create :permission }
    let(:group) { create :group, permissions: [ permission ] }
    let :call do
      user.has_permission?(
        permission.controller, permission.action, permission.id_field
      )
    end
    context 'user is has a permission with no id field' do
      it 'returns true' do
        user.groups << group
        expect(user).to have_permission permission.controller,
                                        permission.action,
                                        nil
      end
    end
    context 'user has a permission with an id_field that matches their ID' do
      it 'returns true' do
        permission.update_attributes id_field: 'id'
        user.groups << group
        expect(user).to have_permission permission.controller,
                                        permission.action,
                                        user.id
      end
    end
    context 'user does not have a given permission' do
      it 'returns false' do
        expect(user).not_to have_permission permission.controller,
                                            permission.action,
                                            nil
      end
    end
    context 'user has the permission but is inactive' do
      it 'returns false' do
        user.groups << group
        user.update_attributes active: false
        expect(user).not_to have_permission permission.controller,
                                            permission.action,
                                            user.id
      end
    end
    context 'user has the permission but the id_field does not match theirs' do
      it 'returns false' do
        user2 = create(:user)
        group = create(:group)
        permission = create(:permission, controller: 'user', action: 'show', id_field: 'id')

        group.permissions << permission
        user.groups << group

        expect(user).not_to have_permission permission.controller,
                                            permission.action,
                                            user2.id
      end
    end
  end

  describe '#has_group?' do
    it 'returns true if the user has the requested group' do
      group = create(:group)

      user.groups << group

      expect(user).to have_group group
    end

    it 'returns false if the user does not have the requested group' do
      group = create(:group)

      expect(user).not_to have_group group
    end
  end
end
