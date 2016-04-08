class Document < ActiveRecord::Base
  validates :filename, presence: true

  def file
    "#{Rails.root}/storage/#{Rails.env}/#{filename}"
  end
end
