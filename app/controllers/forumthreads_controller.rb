class ForumthreadsController < ApplicationController
  def index
    f = Forum.find(params[:id])
    redirect_to forum_path(f.forumgroup, f)
  end

  def show
    @thread = Forumthread.find(params[:id])
    render text: @thread.content
  end

  def new
    @forum = Forum.find(params[:id])
    if @forum && current_user && (@forum.group.role_read.nil? || @forum.group.role_read <= current_user.role) && (@forum.role_read.nil? || @forum.role_read <= current_user.role)
      @thread = Forumthread.new(forum: @forum)
    else
      flash[:alert] = "You are not allowed to create a new thread here!"
      redirect_to @forum
    end
  end

  def create
    @forum = Forum.find(params[:id])
    if (confirmed? && (@forum.group.role_read || Role.get(:default))<= current_user.role && (@forum.group.role_write || Role.get(:default))<= current_user.role && (@forum.role_read || Role.get(:default))<= current_user.role && (@forum.group.role_write || Role.get(:default))<= current_user.role)
      @thread = Forumthread.new(mod? ? params[:forumthread] : params[:forumthread].slice(:title, :content))
      @thread.user_author = current_user
      @thread.forum = @forum
      if @thread.save
        flash[:notice] = "Thread created!"
        redirect_to @thread
        return
      else
        flash[:alert] = "Seomthing went wrong while creating your thread."
        render "new"
        return
      end
    else
      flash[:alert] = "You are not allowed to create a thread here!"
      redirect_to @forum
    end
  end


end