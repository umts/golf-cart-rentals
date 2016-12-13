# frozen_string_literal: true
include SecureRandom
class Document < ActiveRecord::Base
  belongs_to :documentable, polymorphic: true
  enum filetype: %i(picture other)
  validates :filename, :filetype, presence: true
  before_validation :write_file

  attr_readonly :filename # this will be set in the before action
  attr_accessor :uploaded_file # dummy temp field to hold file

  def fetch_file
  end

  private 
    def write_file
      return unless uploaded_file
      begin 
        self.filename = SecureRandom.uuid
        if uploaded_file.content_type.starts_with? "image/"
          self.filetype = :picture
        else
          self.filetype = :other
        end

        File.open(Rails.root.join('storage', Rails.env.to_s, self.filename), 'wb') do |file|
          file.write(self.uploaded_file.read)
        end
      rescue Exception 
        raise Exception.new('Failed to properly write file')
      end
    end
end
