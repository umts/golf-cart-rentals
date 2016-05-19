class DigitalSignaturesController < ApplicationController
  before_action :set_digital_signature, only: [:show, :edit, :update, :destroy]

  # GET /digital_signatures
  def index
    @digital_signatures = DigitalSignature.all
  end

  # GET /digital_signatures/1
  def show
  end

  # GET /digital_signatures/new
  def new
    @digital_signature = DigitalSignature.new
  end

  # GET /digital_signatures/1/edit
  def edit
  end

  # POST /digital_signatures
  def create
    @digital_signature = DigitalSignature.new(digital_signature_params)

    if @digital_signature.save
      redirect_to @digital_signature, notice: 'Digital signature was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /digital_signatures/1
  def update
    if @digital_signature.update(digital_signature_params)
      redirect_to @digital_signature, notice: 'Digital signature was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /digital_signatures/1
  def destroy
    @digital_signature.destroy
    redirect_to digital_signatures_url, notice: 'Digital signature was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_digital_signature
    @digital_signature = DigitalSignature.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def digital_signature_params
    params.require(:digital_signature).permit(:image, :intent)
  end
end
