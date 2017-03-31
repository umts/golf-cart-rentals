# frozen_string_literal: true
include SecureRandom
include Base64
class Document < ActiveRecord::Base
  has_paper_trail
  belongs_to :documentable, polymorphic: true
  enum filetype: %i(picture other)
  validates :filename, :filetype, :original_filename, :description, presence: true # all set during write_file, except desc
  before_validation :write_file

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
      raise e, 'Failed to properly write file'
    end
  end

  def check_kind_of_uploaded_file(uploaded_file)
    raise ArgumentError unless uploaded_file.respond_to? :original_filename
    raise ArgumentError unless uploaded_file.respond_to? :content_type
    raise ArgumentError unless uploaded_file.respond_to? :read
  end
end
