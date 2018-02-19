class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authenticate_user
    if @current_user == nil
      flash[:notice] = "ログインしてください"
      redirect_to("/login")
    end
  end

  def authenticate_designer
    if @current_user.user_group == 1
      flash[:notice] = "デザイナー登録が必要です"
      redirect_to("/users/#{@current_user.id}/signup_designer")
    end
  end

  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/")
    end
  end

  def forbid_login_designer
    if @current_user.user_group == 2
      flash[:notice] = "デザイナー登録済みです"
      redirect_to("/")
      end
  end


end
