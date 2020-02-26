class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :role, :avatar, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :avatar, :email, :password, :password_confirmation, :current_password) }
  end

  def after_sign_out_path_for(resource_or_scope)
    log_path
  end

  def after_sign_in_path_for(resource_or_scope)
    home_path
  end

  def after_update_path_for(resource_or_scope)
    user_path(current_user)
  end

end
