class CommentsController < ApplicationController
 before_action :authenticate_user!
 before_action :ensure_correct_user

def destroy
  @comment = Comment.find_by(id: params[:id],
                             user_id: current_user.id)
  @comment.destroy
  flash[:notice] = "コメントを削除しました"
  redirect_to("/items/#{@comment.post_id}")
end

def ensure_correct_user
  @comment = Comment.find_by(id: params[:id])
  @post = Post.find_by(id: @comment.post_id)
  if current_user.id != @comment.user_id || current_user.id != @post.designer_id
    flash[:notice] = "権限がありません"
    redirect_to("/")
  end
end


end
