class InputsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[ show edit update destroy archive unarchive ]
  before_action :set_input, only: %i[ show edit update destroy archive unarchive authorize_user!  ]

  def index
    @inputs = current_account.inputs
  end

  def show
  end

  def edit

  end

  def new
    @input = Input.new
  end

  def create
    @input = Input.new(input_params)
  end

  private

  def authorize_user!
    unless @input.account_id == current_account.id
      redirect_to inputs_url, notice: "You are not authorized to do that."
    end
  end

  def set_input
    @input = Input.find(params[:id])
  end

  def input_params
    params.require(:input).permit(:text)
  end
end