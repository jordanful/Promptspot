class API::V1::PromptsController < ApplicationController
  before_action :authorize_request

  def index
    prompts = @account.prompts
    respond_to do |format|
      format.json { render json: prompts }
    end
  end

  def show
    prompt = Prompt.find(params[:id])
    respond_to do |format|
      format.json { render json: prompt.as_json.merge(text: prompt.current.text) }
    end
  end

  private

  def authorize_request
    api_key = request.headers['Authorization']
    @account = Account.joins(:api_keys).where(api_keys: { key: api_key }).first if api_key
    unless @account
      render json: { errors: 'Invalid or missing API key' }, status: :unauthorized
    end
  end
end
