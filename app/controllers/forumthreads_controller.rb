class ForumthreadsController < ApplicationController

  before_filter :check_permission

  def index
    redirect_to forum_path(@thread.forum.forumgroup, f)
  end

  def show
  end

  def update
    if mod? || @thread.author.is?(current_user)
      @thread.user_editor = current_user
      if @thread.update_attributes(params[:forumthread].slice(:title, :content, :user_editor))
        redirect_to @thread, notice: 'Post has been updated.'
      else
        flash[:alert] = "There was a problem while updating the post"
        render action: "edit"
      end
    else
      flash[:alert] = "You are not allowed to edit this thread!"
      redirect_to @thread
    end
  end

  def edit
  end

  def new
    @forum = Forum.find(params[:forum_id])
    unless @forum.can_write?(current_user)
      flash[:alert] = "You are not allowed to view this forum"
      redirect_to forums_path
    end
    @thread = Forumthread.new(forum: @forum)
  end

  def create
    @thread = Forumthread.new(mod? ? params[:forumthread] : params[:forumthread].slice(:title, :content))
    if @thread.can_write?(current_user)
      @thread.user_author = current_user
      @thread.forum       = @thread.forum
      if @thread.save
        flash[:notice] = "Thread created!"
        redirect_to forumthread_path( @thread)
        return
      else
        flash[:alert] = "Seomthing went wrong while creating your thread."
        render "new"
        return
      end
    else
      flash[:alert] = "You are not allowed to create a thread here!"
      redirect_to @thread.forum
    end
  end


  private

  def check_permission
    if params[:id]
      @thread = Forumthread.find(params[:id])
      unless @thread.can_read?(current_user)
        flash[:alert] = "You are not allowed to view this thread"
        redirect_to forums_path
      end
    end
  end


end