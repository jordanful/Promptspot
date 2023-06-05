class PromptsController < ApplicationController
  before_action :set_prompt, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /prompts or /prompts.json
  def index
    @prompts = Prompt.all.order(updated_at: :desc)
  end

  # GET /prompts/1 or /prompts/1.json
  def show
  end

  def edit
  end
  
  def new
    @prompt = Prompt.new
    @prompt.prompt_versions.build
  end

  def create
    @prompt = Prompt.new(prompt_params)
    @prompt.account_id = current_user.account.id
    @prompt.prompt_versions.first.user_id = current_user.id
    respond_to do |format|
      if @prompt.save
        format.html { redirect_to @prompt, notice: '👍 Created.' }
        format.json { render :show, status: :created, location: @prompt }
      else
        format.html {
          flash.now[:error] = 'There was an issue creating the prompt. Our team has been alerted.'
          render :new
        }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prompts/1 or /prompts/1.json
  # PATCH/PUT /prompts/1 or /prompts/1.json
  def update
    new_version_text = prompt_params[:prompt_versions_attributes]['0'][:text]
    last_version_text = @prompt.prompt_versions.last.text

    if last_version_text == new_version_text
      redirect_to prompt_url(@prompt), notice: "No changes were made."
    else
      @prompt.assign_attributes(prompt_params)

      @prompt.prompt_versions.each do |pv|
        pv.user = current_user if pv.new_record?
      end

      respond_to do |format|
        if @prompt.save
          format.html { redirect_to prompt_url(@prompt), notice: "Prompt was successfully updated." }
          format.json { render :show, status: :ok, location: @prompt }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @prompt.errors, status: :unprocessable_entity }
        end
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
    params.require(:prompt).permit(:status, :account_id, prompt_versions_attributes: [:text])
  end

end
