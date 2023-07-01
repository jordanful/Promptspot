class API::V1::InputsController < ApplicationController
  before_action :authorize_request

  def create
    input = Input.new(account_id: @account.id, text: params[:text])
    if input.save
      respond_to do |format|
        format.json { render json: input }
      end
    else
      respond_to do |format|
        format.json { render json: input.errors }
      end
    end
  end

  def index
    inputs = @account.inputs
    respond_to do |format|
      format.json { render json: inputs }
    end
  end

  def show
    input = Input.find(params[:id])
    respond_to do |format|
      format.json { render json: input }
    end
  end

  def update
    input = Input.find(params[:id])
    if input.update(text: params[:text])
      respond_to do |format|
        format.json { render json: input }
      end
    else
      respond_to do |format|
        format.json { render json: input.errors }
      end
    end
  end

  def destroy
    input = Input.find(params[:id])
    if input.destroy
      respond_to do |format|
        format.json { render status: :ok, json: { message: 'Input deleted' } }
      end
    else
      respond_to do |format|
        format.json { render json: input.errors }
      end
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
