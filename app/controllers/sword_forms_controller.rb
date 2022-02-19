class SwordFormsController < ApplicationController
  before_action :set_sword_form, only: [:show, :edit, :update, :destroy]

  # GET /sword_forms or /sword_forms.json
  def index
    @sword_forms = SwordForm.all
  end

  # GET /sword_forms/1 or /sword_forms/1.json
  def show; end

  # GET /sword_forms/new
  def new
    @sword_form = SwordForm.new
  end

  # GET /sword_forms/1/edit
  def edit; end

  # POST /sword_forms or /sword_forms.json
  def create
    @sword_form = SwordForm.new(sword_form_params)

    respond_to do |format|
      if @sword_form.save
        format.html { redirect_to sword_form_url(@sword_form), notice: 'Sword form was successfully created.' }
        format.json { render :show, status: :created, location: @sword_form }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sword_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sword_forms/1 or /sword_forms/1.json
  def update
    respond_to do |format|
      if @sword_form.update(sword_form_params)
        format.html { redirect_to sword_form_url(@sword_form), notice: 'Sword form was successfully updated.' }
        format.json { render :show, status: :ok, location: @sword_form }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sword_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sword_forms/1 or /sword_forms/1.json
  def destroy
    @sword_form.destroy

    respond_to do |format|
      format.html { redirect_to sword_forms_url, notice: 'Sword form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sword_form
    @sword_form = SwordForm.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sword_form_params
    params.require(:sword_form).permit(:name, :description)
  end
end
