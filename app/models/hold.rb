# frozen_string_literal: true
class Hold < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :item

  validates :hold_reason, :end_time, :item_type_id, presence: true
  validates :end_time, date: { after: :start_time, message: 'must be after start time' }

end
