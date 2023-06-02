class PromptsController < ApplicationController
  before_action :set_prompt, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /prompts or /prompts.json
  def index
    @prompts = Prompt.all
  end

  # GET /prompts/1 or /prompts/1.json
  def show
  end

  # GET /prompts/new

  # GET /prompts/1/edit
  def edit
  end

  # POST /prompts or /prompts.json
  def new
    @prompt = Prompt.new
    @prompt.prompt_versions.build
  end

  def create
    @prompt = Prompt.new(prompt_params)

    if @prompt.save
      redirect_to @prompt, notice: 'Prompt was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /prompts/1 or /prompts/1.json
  def update
    respond_to do |format|
      if @prompt.update(prompt_params)
        format.html { redirect_to prompt_url(@prompt), notice: "Prompt was successfully updated." }
        format.json { render :show, status: :ok, location: @prompt }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prompts/1 or /prompts/1.json
  def destroy
    @prompt.destroy

    respond_to do |format|
      format.html { redirect_to prompts_url, notice: "Prompt was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_prompt
    @prompt = Prompt.find(params[:id])
  end

  # Only allow a list of trusted parameters through.

  def prompt_params
    params.require(:prompt).permit(:status, :account_id, prompt_versions_attributes: [:text, :user_id])
  end
end
