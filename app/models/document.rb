class Document < ActiveRecord::Base
  belongs_to :incurred_incidental
  validates :filename, :incurred_incidental_id, presence: true

  def file
    "#{Rails.root}/storage/#{Rails.env}/#{filename}"
  end
end
