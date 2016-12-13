class DocumentsController < ApplicationController
  before_action :set_document

  def show
    send_data @document.fetch_file, filename: @document.description
  end

  private 
    def set_document
      @document = Document.find params[:id]
    end
end
