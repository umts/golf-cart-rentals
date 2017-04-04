# frozen_string_literal: true
class GroupsPermission < ActiveRecord::Base
  has_paper_trail
  belongs_to :group
  belongs_to :permission
  validates :group, :permission, presence: true
end
