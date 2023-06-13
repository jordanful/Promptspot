class ApplicationController < ActionController::Base
  before_action :set_current_organization
  before_action :set_current_account

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end

  private

  def set_current_organization
    @current_organization = current_user.account.organization if current_user
  end

  def set_current_account
    @current_account = current_user.account if current_user
  end

end
