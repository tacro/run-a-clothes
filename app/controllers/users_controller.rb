class UsersController < ApplicationController
  before_action :authenticate_user!, {only: [:index, :logout,:edit,:update, :register_designer, :update_designer, :following_posts]}
  before_action :ensure_correct_user, {only: [:edit, :update, :following_posts]}
  before_action :set_s3_direct_post, only: [:edit, :update]

  def index
    @q = User.search(params[:q])
    @users = @q.result.order(created_at: :desc)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

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
      users = User.find(params[:id]).followings
      @posts = []
      if users.present?
        users.each do |user|
          posts = Post.where(designer_id: user.id).order(created_at: :desc)
          @posts.concat(posts)
        end
        if @posts.nil?
          flash[:notice]="まだ投稿がありません…"
          redirect_to("/")
        end
        @posts.sort_by{|post| post.id}
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

  private
  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "user_images/avatar/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
  end
end
