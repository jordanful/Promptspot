class ApplicationController < ActionController::Base
  before_action :set_current_account
  before_action :set_current_organization
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end

  private

  def set_current_account
    if current_user
      @current_account = current_user.accounts.first # TODO: Fix this and allow the user to select an account
    end
  end

  def set_current_organization
    if current_user && @current_account
      @current_organization = @current_account.organization
    end
  end

end
