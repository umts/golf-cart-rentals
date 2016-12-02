# frozen_string_literal: true
include SecureRandom
class Document < ActiveRecord::Base
  validates :filename, presence: true
  belongs_to :documentable, polymorphic: true
  
  before_create :write_file

  attr_readonly :filename # this will be set in the before action
  attr_accessor :uploaded_file # dummy temp field to hold file

  private 
    def write_file
      begin 
        self.filename = SecureRandom.uuid
        File.open(Rails.root.join('storage', Rails.env.to_s, self.filename), 'wb') do |file|
          file.write(self.uploaded_file.read)
        end
      rescue Exception 
        raise Exception.new('Failed to properly write file')
      end
    end
end
