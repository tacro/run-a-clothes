class UsersController < ApplicationController
before_action :authenticate_user, {only: [:logout,:edit,:update, :register_designer, :update_designer]}
before_action :ensure_correct_user, {only: [:edit, :update]}
before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
before_action :forbid_login_designer, {only: [:new_designer, :register_designer]}

  def new
    @user = User.new
  end

  def create
     @user = User.new(
       name: params[:name],
       email: params[:email],
       password: params[:password],
       user_group: 1,
       icon_image_name: "default_icon.png",
     )
     if params[:gender][:type] == "女性" then
       @user.gender= 0
     elsif params[:gender][:type] == "男性" then
       @user.gender= 1
     elsif params[:gender][:type] == "その他" then
       @user.gender= 2
     end
     if @user.save
       session[:user_id] = @user.id
       flash[:notice] = "ユーザー登録が完了しました"
       redirect_to("/")
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
      flash[:notice] = "successfully logged in"
      redirect_to("/users/#{@user.id}")
    else
      @email = params[:email]
      @error_message = "メールアドレスまたはパスワードが間違っています"
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil;
    flash[:notice] = "logged out"
    redirect_to("/login")
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    if params[:image]
      @user.icon_image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    if @user.save
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
    @user.name = params[:designer_name]
    @user.brand_name = params[:brand_name]
    @user.user_group = 2
    if params[:image]
      @user.icon_image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    if @user.save
      flash[:notice]="デザイナー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new_designer")
    end
  end

  def update_designer
    @user = User.find_by(id: params[:id])
    @user.name = params[:designer_name]
    @user.brand_name = params[:brand_name]
    @user.designer_profile = params[:profile]
    @user.email = params[:email]
    if params[:image]
      @user.icon_image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    if @user.save
      flash[:notice]="デザイナー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
