class ItemType < ActiveRecord::Base
  has_one :fee_schedule, dependent: :destroy
end
