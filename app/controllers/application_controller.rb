class ApplicationController < ActionController::Base
  protected

  def current_account
    @current_account ||= current_user.account
  end

  def current_organization
    @current_organization ||= current_user.organization
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end

end
