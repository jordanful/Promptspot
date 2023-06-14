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
    if current_user
      Rails.logger.info "Current user: #{current_user.inspect}"
      Rails.logger.info "Current user's account: #{current_user.account.inspect}"
      @current_organization = current_user.account.organization
      Rails.logger.info "Current organization: #{@current_organization.inspect}"
    else
      Rails.logger.info "No current user"
    end
  end

  def set_current_account
    if current_user
      Rails.logger.info "Current user: #{current_user.inspect}"
      @current_account = current_user.account
      Rails.logger.info "Current account: #{@current_account.inspect}"
    else
      Rails.logger.info "No current user"
    end
  end

end
