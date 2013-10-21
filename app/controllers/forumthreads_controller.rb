class ForumthreadsController < ApplicationController
  def index
    f = Forum.find(params[:id])
    redirect_to forum_path(f.forumgroup, f)
  end

  def new
    @forum = Forum.find(params[:id])
    if @forum && current_user && (@forum.group.role_read.nil? || @forum.group.role_read <= current_user.role) && (@forum.role_read.nil? || @forum.role_read <= current_user.role)
      @thread = Forumthread.new(forum: @forum)
    else
      flash[:alert] = "You are not allowed to create a new thread here!"
    end
  end

  def create
    flash[:alert] = "Not yet ;("
    redirect_to forum_path(params[:id])
  end


end