# frozen_string_literal: true
class Item < ActiveRecord::Base
  belongs_to :item_type

  validates :name, :item_type_id, presence: true

  default_scope { where(deleted_at: nil) }

  delegate :name, :base_fee, :fee_per_day, to: :item_type, prefix: true

  def self.deleted
    unscoped.where('deleted_at IS NOT NULL')
  end

  def self.all_reservable_items
    Item.all.select { |i| Inventory.item(i.uuid)[:reservable] }
  end

  def basic_info
    "#{name} (#{item_type.name})"
  end
end
