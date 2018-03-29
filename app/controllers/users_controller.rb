class UsersController < ApplicationController
before_action :authenticate_user, {only: [:logout,:edit,:update, :register_designer, :update_designer]}
before_action :ensure_correct_user, {only: [:edit, :update]}
before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
before_action :forbid_login_designer, {only: [:new_designer, :register_designer]}

  def new
    @user = User.new
  end

  def create
    user = params.require(:user).permit(
      :name,
      :user_group,
      :gender,
      :email,
      :password
    )
     @user = User.new(user)
     if @user.save
       session[:user_id] = @user.id
       flash[:notice] = "ユーザー登録が完了しました"
       redirect_to("/")
       NotificationMailer.signup_email(@user).deliver
     else
       render("users/new")
     end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def login_form
  end

  def login
    @user = User.find_by(
      email: params[:email]
    )
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/users/#{@user.id}")
    else
      @email = params[:email]
      @error_message = "メールアドレスまたはパスワードが間違っています"
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil;
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    user = params.require(:user).permit(
      :name,
      :icon_image_name,
      :email
    )
    if @user.update_attributes(user)
      flash[:notice]="ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end

  def new_designer
    @user = @current_user
  end

  def register_designer
    @user = User.find_by(id: params[:id])
    user = params.require(:user).permit(
      :name,
      :brand_name,
      :icon_image_name,
      :user_group
    )
    if @user.update_attributes(user)
      flash[:notice]="デザイナー登録が完了しました"
      redirect_to("/users/#{@user.id}")
      NotificationMailer.desginersignup_email(@user).deliver
    else
      render("users/new_designer")
    end
  end

  def update_designer
    @user = User.find_by(id: params[:id])
    user = params.require(:user).permit(
      :name,
      :brand_name,
      :icon_image_name,
      :designer_profile,
      :email
    )
    if @user.update_attributes(user)
      flash[:notice]="デザイナー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end

  #follow-related functions
  def following
      @user  = User.find(params[:id])
      @users = @user.followings
      render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'show_follower'
  end

end
