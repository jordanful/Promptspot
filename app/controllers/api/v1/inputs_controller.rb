class API::V1::ContextsController < ApplicationController
  include API::V1::Shared

  before_action :authorize_request

  def create
    context = Context.new(account_id: @account.id, text: params[:text])
    if context.save
      respond_to do |format|
        format.json { render json: context }
      end
    else
      respond_to do |format|
        format.json { render json: context.errors }
      end
    end
  end

  def index
    contexts = @account.contexts
    respond_to do |format|
      format.json { render json: contexts }
    end
  end

  def show
    context = Context.find(params[:id])
    respond_to do |format|
      format.json { render json: context }
    end
  end

  def update
    context = Context.find(params[:id])
    if context.update(text: params[:text])
      respond_to do |format|
        format.json { render json: context }
      end
    else
      respond_to do |format|
        format.json { render json: context.errors }
      end
    end
  end

  def destroy
    context = Context.find(params[:id])
    if context.destroy
      respond_to do |format|
        format.json { render status: :ok, json: { message: 'Context deleted' } }
      end
    else
      respond_to do |format|
        format.json { render json: context.errors }
      end
    end
  end

end
