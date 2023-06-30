class API::V1::APIKeysController < ApplicationController

  def refresh
    key = APIKey.find_by(key: params[:id])
    key.deactivate
    new_key = APIKey.create!(account_id: key.account_id)
    respond_to do |format|
      format.json { render json: { key: new_key.key } }
      format.html { redirect_to api_v1_docs_path, notice: 'Refreshed API key.' }
    end

  end
end
