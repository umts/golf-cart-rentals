# frozen_string_literal: true
class DigitalSignaturesController < ApplicationController
  before_action :set_digital_signature, only: [:show]

  # GET /digital_signatures
  def index
    @digital_signatures = DigitalSignature.all
  end

  # GET /digital_signatures/1
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_digital_signature
    @digital_signature = DigitalSignature.find(params[:id])
  end
end
