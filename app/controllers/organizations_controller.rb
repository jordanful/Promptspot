class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[ update  ]
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[ update]

  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to account_url(@current_account), notice: "👍 Saved" }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def organization_params
    params.require(:organization).permit(:billing_email, :openai_api_key, :timezone)
  end

  def authorize_user!
    unless @current_account.organization_id == @organization.id
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
end
