# frozen_string_literal: true
class Item < ActiveRecord::Base
  belongs_to :item_type
  validates :name, :item_type_id, presence: true
  default_scope { where(deleted_at: nil) }

  def self.deleted
    unscoped.where('deleted_at IS NOT NULL')
  end

  delegate :name, :base_fee, :fee_per_day, :disclaimer, to: :item_type, prefix: true
end
