require 'diffy'

class PromptVersionsController < ApplicationController
  before_action :set_prompt_version, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def show
    @previous_version = @prompt_version.prompt.prompt_versions.where("version_number < ?", @prompt_version.version_number)
                                       .order(version_number: :desc)
                                       .first

    if @previous_version
      @diff_split = Diffy::SplitDiff.new(@previous_version.text, @prompt_version.text, format: :html, include_plus_and_minus_in_html: true)
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
