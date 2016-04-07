class Document < ActiveRecord::Base
  belongs_to :incurred_incidental
  validates :filename, presence: true

  def file
    "#{Rails.root}/storage/#{Rails.env}/#{filename}"
  end
end
