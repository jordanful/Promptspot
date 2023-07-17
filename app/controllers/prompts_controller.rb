class PromptsController < ApplicationController
  before_action :set_prompt, only: %i[ show edit update destroy archive unarchive create_draft ]
  before_action :authenticate_user!
  before_action :authorize_user!, except: %i[ new index create_draft create destroy ]

  # GET /prompts or /prompts.json
  def index
    @prompts = if params[:query].present?
                 @current_account.prompts.where.not(status: 'archived').where('title LIKE ?', "%#{params[:query]}%").order(updated_at: :desc)
               else
                 @current_account.prompts.where.not(status: 'archived').order(updated_at: :desc)
               end
  end

  # GET /prompts/1 or /prompts/1.json
  def show

  end

  def edit
    @inputs = @current_account.inputs.order(updated_at: :desc)
    @models = Model.where(enabled: true).order(Arel.sql("CASE WHEN name = 'text-davinci-003' THEN 0 WHEN name = 'gpt-3.5-turbo' THEN 1 ELSE 2 END, name"))
    @new_prompt_version = @prompt.prompt_versions.build(text: @prompt.prompt_versions.last.text)
    return unless params[:draft].present?

    @prompt_draft = PromptDraft.find(params[:draft])

  end

  def new
    @prompt = Prompt.new
    @prompt.prompt_versions.build
  end

  def create
    @prompt = Prompt.new(prompt_params)
    if @current_organization.openai_api_key.blank? && @prompt.title.blank?
      flash[:error] = "Please set your OpenAI API key first."
      redirect_to edit_user_registration_url and return
    end
    @prompt.account_id = @current_account.id
    @prompt.prompt_versions.build if @prompt.prompt_versions.empty?
    @prompt.prompt_versions.last.user = current_user
    draft_id = params[:prompt_draft_id]

    respond_to do |format|

      if @prompt.save
        if draft_id.present?
          PromptDraft.find(draft_id).destroy
        end
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
  def update
    new_version_text = prompt_params.dig("prompt_versions_attributes", "0", "text")
    last_version_text = @prompt.prompt_versions.order(version_number: :desc).first.text
    draft_id = params[:prompt_draft_id]

    # TODO - Save if the user updated the title but not the body
    if new_version_text.nil? || last_version_text == new_version_text
      redirect_to prompt_url(@prompt), notice: "No changes were made."
    else
      @prompt.assign_attributes(prompt_params)

      @prompt.prompt_versions.each do |pv|
        pv.user = current_user if pv.new_record?
      end

      respond_to do |format|
        if @prompt.save
          if draft_id.present?
            PromptDraft.find(draft_id).destroy
          end
          format.html { redirect_to prompt_url(@prompt), notice: "Updated" }
          format.json { render :show, status: :ok, location: @prompt }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @prompt.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def create_draft
    if params[:prompt_draft_id].present?
      @prompt_draft = PromptDraft.find(params[:prompt_draft_id])
      @prompt_draft.text = params[:text]
    else
      prompt = Prompt.find(params[:id])
      @prompt_draft = prompt.prompt_drafts.new(prompt_draft_params)
      @prompt_draft.user_id = current_user.id
    end

    if @prompt_draft.save
      render json: { message: 'Draft was successfully saved.', location: prompt_path(prompt) }, status: :created
    else
      logger.warn "Failed to save draft: #{@prompt_draft.errors.full_messages.join(", ")}"
      render json: { error: @prompt_draft.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def archived
    @prompts = @current_account.prompts.where(status: 'archived').order(updated_at: :desc)
    respond_to do |format|
      format.turbo_stream
      format.html { render :index }
    end
  end

  def archive
    @prompt.archive!
    flash[:notice] = "👍 Archived #{view_context.button_to('Undo', unarchive_prompt_path(@prompt), method: :post, class: 'underline mx-3 inline-block')}".html_safe
    redirect_to prompts_url
  end

  def unarchive
    @prompt.unarchive!
    redirect_to prompt_path(@prompt), notice: "✅ Unarchived"
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
    params.require(:prompt).permit(:status, :account_id, :title, prompt_versions_attributes: [:text, :id])
  end

  def prompt_draft_params
    params.permit(:text)
  end

  def authorize_user!
    return if @current_account.id == @prompt.account_id
    redirect_to prompts_path, notice: "You do not have access to that prompt."

  end

end
