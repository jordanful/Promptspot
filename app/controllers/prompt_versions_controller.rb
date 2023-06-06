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

  def preview
    user_prompt = UserPrompt.find_or_initialize_by(text: params[:user_prompt], account_id: current_user.account.id)
    user_prompt.user_id = current_user.id
    user_prompt.save
    prompt = params[:system_prompt] + '/n/n' + params[:user_prompt]
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_SECRET"])
    response = client.completions(
      parameters: {
        model: params[:model],
        prompt: prompt,
        max_tokens: Rails.application.config.max_tokens
      }
    )
    @result = response["choices"][0]["text"]
    render partial: 'preview', locals: { result: @result }
  rescue
    render partial: 'preview', locals: { result: 'Error' }
    Rails.logger.error "Error: #{$!}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_prompt_version
    @prompt_version = PromptVersion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def prompt_version_params
    params.require(:prompt_version).permit(:prompt_id, :user_id, :text, :save_user_prompt, :user_prompt)
  end
end
