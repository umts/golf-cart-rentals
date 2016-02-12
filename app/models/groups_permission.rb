class GroupsPermission < ActiveRecord::Base
  belongs_to :group
  belongs_to :permission
end
