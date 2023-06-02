class PromptVersionsController < ApplicationController
  before_action :set_prompt_version, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /prompt_versions or /prompt_versions.json
  def index
    @prompt_versions = PromptVersion.all
  end

  # GET /prompt_versions/1 or /prompt_versions/1.json
  def show
  end

  # GET /prompt_versions/new
  def new
    @prompt_version = PromptVersion.new
  end

  # GET /prompt_versions/1/edit
  def edit
  end

  # POST /prompt_versions or /prompt_versions.json
  def create
    @prompt_version = PromptVersion.new(prompt_version_params)

    respond_to do |format|
      if @prompt_version.save
        format.html { redirect_to prompt_version_url(@prompt_version), notice: "Prompt version was successfully created." }
        format.json { render :show, status: :created, location: @prompt_version }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prompt_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prompt_versions/1 or /prompt_versions/1.json
  def update
    respond_to do |format|
      if @prompt_version.update(prompt_version_params)
        format.html { redirect_to prompt_version_url(@prompt_version), notice: "Prompt version was successfully updated." }
        format.json { render :show, status: :ok, location: @prompt_version }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prompt_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prompt_versions/1 or /prompt_versions/1.json
  def destroy
    @prompt_version.destroy

    respond_to do |format|
      format.html { redirect_to prompt_versions_url, notice: "Prompt version was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_prompt_version
    @prompt_version = PromptVersion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def prompt_version_params
    params.require(:prompt_version).permit(:prompt_id, :user_id, :text)
  end
end
