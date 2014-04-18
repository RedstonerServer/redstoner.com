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
      if @thread.update_attributes thread_params([:user_editor])
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
    @thread = Forumthread.new(forum: Forum.find(params[:forum]))
    unless @thread.forum.can_write?(current_user)
      flash[:alert] = "You are not allowed to write in this forum"
      redirect_to forums_path
    end
  end

  def create
    @thread = Forumthread.new(mod? ? thread_params([:sticky, :locked, :forum_id]) : thread_params([:forum_id]))
    if @thread.can_write?(current_user)
      @thread.user_author = current_user
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

  def thread_params(add = [])
    a = [:title, :content]
    a += add
    params.require(:forumthread).permit(a)
  end
end