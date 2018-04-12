class PostsController < ApplicationController
  before_action :authenticate_user!, {only: [:comment, :new, :create, :edit, :update, :destroy]}
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  before_action :set_s3_direct_post, only: [:new, :create]
  # before_action :authenticate_designer, {only: [:new, :create, :edit, :update, :destroy]}

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def search_form
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
  end

  def search
    @q = Post.search(params.require(:q).permit)
    @posts = @q.result(distinct: true)
  end

  def create
    post = params.require(:post).permit(
      # :name,
      :designer_id,
      # {image_name: []},
      :image_name,
      # :remote_image_url,
      # :price,
      # :caption,
      :detail
    )
    # post[:image_name]= post[:remote_image_url]
    # post[:remote_image_url] = ""
    @post = Post.new(post)
    if @post.save
      flash[:notice]="投稿しました"
      redirect_to("/")
      # NotificationMailer.post_email(current_user, @post).deliver
    else
      render("posts/new")
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @comments = Comment.where(post_id: @post.id)
    @likes_count = Like.where(post_id: @post.id).count
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    post = params.require(:post).permit(
      # :name,
      :designer_id,
      # {image_name: []},
      # :image_name,
      # :remote_image_url,
      # :price,
      # :caption,
      :detail
    )
    if @post.update_attributes(post)
      flash[:notice]="投稿を編集しました"
      redirect_to("/items/#{@post.id}")
    else
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    @likes = Like.where(post_id: @post.id)
    if @likes
        @likes.each do |like|
          like.destroy
        end
    end
    flash[:notice] = "投稿を削除しました"
    redirect_to("/users/#{current_user.id}")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if current_user.id != @post.designer_id
      flash[:notice] = "権限がありません"
      redirect_to("/items/#{@post.id}")
    end
  end

  def comment
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new(comment: params[:comment],
                          post_id: @post.id,
                          user_id: current_user.id)
    @comment.save
    redirect_to :action => "show", :id => @comment.post_id
  end

  def hashtags
    @tag = Tag.find_by(name: params[:name])
    @posts = @tag.posts
    @num = @posts.length
  end

  private
  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "post_images/images/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
  end

end
