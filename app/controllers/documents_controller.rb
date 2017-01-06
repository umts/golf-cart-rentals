# frozen_string_literal: true
class DocumentsController < ApplicationController
  before_action :set_document

  def show
    send_data @document.fetch_file, filename: @document.original_filename
  end

  private

  def set_document
    @document = Document.find params.require(:id)
  end
end
