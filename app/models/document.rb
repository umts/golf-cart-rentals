# frozen_string_literal: true
class Document < ActiveRecord::Base
  validates :filename, presence: true
  belongs_to :documentable, polymorphic: true

  def file
    "#{Rails.root}/storage/#{Rails.env}/#{filename}"
  end
end
