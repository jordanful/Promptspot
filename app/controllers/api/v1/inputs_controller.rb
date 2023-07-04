class API::V1::InputsController < ApplicationController
  include API::V1::Shared

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
  
end
