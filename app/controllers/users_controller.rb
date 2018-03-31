class UsersController < ApplicationController
  before_action :authenticate_user!, {only: [:logout,:edit,:update, :register_designer, :update_designer, :following_posts]}
  before_action :ensure_correct_user, {only: [:edit, :update, :following_posts]}
  
  def show
    @user = User.find_by(id: params[:id])
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    user = params.require(:user).permit(
      :username,
      :avatar,
      :profile
    )
    if @user.update_attributes(user)
      flash[:notice]="プロフィールを変更しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
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

  def following_posts
      @user  = User.find(params[:id])
      @users = @user.followings
      if @users.present?
        @users.each do |user|
          @designer = User.find_by(id: user.id)
          @posts = Post.where(designer_id: user.id)
          if @posts.empty?
            flash[:notice]="まだ投稿がありません…"
            redirect_to("/")
          end
        end
      else
        flash[:notice]="誰かをフォローしてみましょう！"
        redirect_to("/")
      end
  end

  def ensure_correct_user
    if current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
