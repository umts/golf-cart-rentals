class FeeSchedule < ActiveRecord::Base
  #need to one to one relationship with car type table.
  belongs_to :item_type
end
