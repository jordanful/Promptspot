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
    if params[:input_id].present?
      input = Input.find(params[:input_id])
    else
      input = Input.find_or_initialize_by(text: params[:input], account_id: @current_account.id)
      input.user_id = current_user.id
      input.save
    end

    prompt = "#{params[:system_prompt]}\n\n#{input.text}"
    client = OpenAI::Client.new(access_token: @current_organization.openai_api_key)
    response = client.completions(
      parameters: {
        model: params[:model],
        prompt: prompt,
        max_tokens: Rails.application.config.max_tokens
      }
    )
    @result = response["choices"][0]["text"]

    render json: { result: @result }
  rescue StandardError => e
    Rails.logger.error "Error: #{e.message}"
    render json: { result: 'Error', error: e.message }, status: :internal_server_error
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_prompt_version
    @prompt_version = PromptVersion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def prompt_version_params
    params.require(:prompt_version).permit(:prompt_id, :user_id, :text, :save_input, :input)
  end
end
