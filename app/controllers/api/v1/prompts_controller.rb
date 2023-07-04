class API::V1::PromptsController < ApplicationController
  include API::V1::Shared
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

end
