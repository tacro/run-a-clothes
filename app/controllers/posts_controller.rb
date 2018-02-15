class PostsController < ApplicationController
  before_action :authenticate_user, {only: [:new, :comment]}
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  before_action :authenticate_designer, {only: [:create, :edit, :update, :destroy]}

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    if @current_user.user_group == 1
      flash[:notice]="出品にはデザイナー登録が必要です"
      redirect_to("/signup_designer")
    end
    @post = Post.new
  end

  def create
    @post = Post.new(
      name: params[:name],
      price: params[:price],
      designer_id: @current_user.id,
      caption: params[:caption],
      detail: params[:detail]
    )
    if params[:image]
      image = params[:image]
      @post.image_name = "#{SecureRandom.uuid}.jpg"
      File.binwrite("public/post_images/#{@post.image_name}", image.read)
    end
    if @post.save
      flash[:notice]="posted!"
      redirect_to("/")
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
    @post.name = params[:name]
    @post.price = params[:price]
    @post.caption = params[:caption]
    @post.detail =  params[:detail]
    if params[:image]
      image = params[:image]
      @post.image_name = "#{SecureRandom.uuid}.jpg"
      File.binwrite("public/post_images/#{@post.image_name}", image.read)
    end
    if @post.save
      flash[:notice]="投稿を編集しました"
      redirect_to("/posts/#{@post.id}")
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
    redirect_to("/users/#{@current_user.id}")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @current_user.id != @post.designer_id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/#{@post.id}")
    end
  end

  def comment
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new(comment: params[:comment],
                          post_id: @post.id,
                          user_id: @current_user.id)
    @comment.save
    redirect_to :action => "show", :id => @comment.post_id
  end


end
