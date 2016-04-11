class Note < ActiveRecord::Base
  belongs_to :noteable, polymorphic: true

  validates :note, presence: true
end
