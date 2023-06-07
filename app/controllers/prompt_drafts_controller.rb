class PromptDraftsController < ApplicationController
  before_action :set_prompt_draft, only: %i[ update destroy authorize_user! ]
  before_action :authenticate_user!
  before_action :authorize_user!

  def update

  end

  def destroy
    prompt = @prompt_draft.prompt
    @prompt_draft.destroy
    render json: { message: 'Draft was successfully deleted.', location: prompt_path(prompt) }, status: :ok
  end

  private

  def authorize_user!
    unless @prompt_draft.user == current_user
      redirect_to prompts_url, notice: "You are not authorized to do that."
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_prompt_draft
    @prompt_draft = PromptDraft.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def prompt_draft_params
    params.permit(:text)
  end

end
