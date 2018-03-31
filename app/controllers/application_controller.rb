class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
        "/users/#{current_user.id}"
    end


  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :user_group, :accepted])
      # devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end

  def forbid_login_user
    if user_signed_in?
      flash[:notice] = "すでにログインしています"
      redirect_to("/")
    end
  end

end
