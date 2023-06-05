require 'diffy'

class PromptVersionsController < ApplicationController
  before_action :set_prompt_version, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /prompt_versions/1 or /prompt_versions/1.json
  def show

    @diff_split = Diffy::SplitDiff.new(@prompt_version.text, @prompt_version.prompt.prompt_versions.last.text, format: :html, include_plus_and_minus_in_html: true)
    @diff = Diffy::Diff.new(@prompt_version.text, @prompt_version.prompt.prompt_versions.last.text, include_plus_and_minus_in_html: true).to_s(:html)
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
