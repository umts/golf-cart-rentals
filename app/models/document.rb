# frozen_string_literal: true
include SecureRandom
include Base64
class Document < ActiveRecord::Base
  has_paper_trail

  enum filetype: %i(picture other)

  belongs_to :documentable, polymorphic: true
  
  before_validation :write_file
  # all set during write_file, except desc
  validates :filename, :filetype, :original_filename, :description, presence: true

  attr_readonly :filename # this will be set in the before action
  attr_accessor :uploaded_file # dummy temp field to hold file

  def fetch_file_as_base64
    Base64.encode64(fetch_file) if persisted?
  end

  def fetch_file
    File.read(Rails.root.join('storage', Rails.env.to_s, filename)) if persisted?
  end

  private

  def write_file
    return if filename # already stored file, will break if we try again
    return unless uploaded_file # this is a temp variable in this class, it wont be written to the database
    begin
      # this method can take multiple uploaded_file types but they need to have these methods.
      check_kind_of_uploaded_file(uploaded_file)

      self.filename = SecureRandom.uuid
      self.original_filename = uploaded_file.original_filename
      self.filetype = if uploaded_file.content_type.starts_with? 'image/'
                        :picture
                      else
                        :other
                      end

      File.open(Rails.root.join('storage', Rails.env.to_s, filename), 'wb') do |file|
        file.write(uploaded_file.read)
      end
    rescue => e
      self.filename = nil # reset so we can write again
      raise e, 'Failed to properly write file'
    end
  end

  def check_kind_of_uploaded_file(uploaded_file)
    raise ArgumentError unless uploaded_file.respond_to? :original_filename
    raise ArgumentError unless uploaded_file.respond_to? :content_type
    raise ArgumentError unless uploaded_file.respond_to? :read
  end
end
