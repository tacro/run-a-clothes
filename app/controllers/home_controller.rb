class HomeController < ApplicationController
  def top
    @posts = Post.all.order(created_at: :desc)
  end

  def about
  end

  def terms
  end

  def privacy
  end
end
