class ContextsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_context, only: %i[ show edit update destroy archive unarchive authorize_user!  ]
  before_action :authorize_user!, only: %i[ show edit update destroy]

  def index
    @contexts = @current_account.contexts
  end

  def show
  end

  def edit

  end

  def new
    @context = Context.new
  end

  def create
    @context = Context.new(context_params)
    @context.account_id = @current_account.id
    @context.user_id = current_user.id
    respond_to do |format|
      if @context.save
        format.html { redirect_to contexts_url, notice: "👍 All set." }
        format.json { render :show, status: :created, location: @context }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @context.update(context_params)
        format.html { redirect_to contexts_url, notice: "👍 All set." }
        format.json { render :show, status: :ok, location: @context }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @context.destroy
    respond_to do |format|
      format.html { redirect_to contexts_url, notice: "👍 Deleted." }
      format.json { head :no_content }
    end
  end

  private

  def authorize_user!
    unless @context.account_id == @current_account.id
      redirect_to contexts_url, notice: "You are not authorized to do that."
    end
  end

  def set_context
    @context = Context.find(params[:id])
  end

  def context_params
    params.require(:context).permit(:text, :title)
  end
end