class TagsController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = Tag.search(params[:q])
    @tags = @q.result.order(created_at: :desc)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end
end
