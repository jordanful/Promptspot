class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show ]
  before_action :authenticate_user!

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:organization_id)
  end
end
