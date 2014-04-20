class ThreadrepliesController < ApplicationController

  def edit
    @reply = Threadreply.find(params[:id])
    if mod? || @reply.author.is?(current_user)
    else
      flash[:alert] = "You are not allowed to edit this reply"
      redirect_to @reply.thread
    end
  end

  def create
    thread = Forumthread.find(params[:forumthread_id])
    if thread.can_write?(current_user)
      @reply = Threadreply.new(reply_params)
      @reply.user_author = current_user
      @reply.forumthread = thread
      if @reply.save
        redirect_to forumthread_path(@reply.thread) + "#reply-#{@reply.id}", notice: 'Reply created!'
      else
        flash[:alert] = "Could not create reply."
        redirect_to Forumthread.find(params[:forumthread_id])
      end
    else
      flash[:alert] = "You are not allowed to create replies."
      redirect_to Forumthread.find(params[:forumthread_id])
    end
  end

  def update
    @reply = Threadreply.find(params[:id])
    if mod? || @reply.author.is?(current_user)
      if @reply.update_attributes(reply_params)
        flash[:notice] = "Reply updated!"
        redirect_to forumthread_path(@reply.thread) + "#reply-#{@reply.id}"
      else
        flash[:alert] = "There was a problem while updating your reply"
        render action: "edit"
      end
    else
      flash[:alert] = "You are not allowed to edit this reply"
      redirect_to @reply.thread
    end
  end

  def destroy
    @reply = Threadreply.find(params[:id])
    if mod? || @reply.author.is?(current_user)
      if @reply.destroy
        flash[:notice] = "Reply deleted!"
      else
        flash[:alert] = "There was a problem while deleting this reply"
      end
    else
      flash[:alert] = "You are not allowed to delete this reply"
    end
    redirect_to @reply.thread
  end

  private

  def reply_params
    params.require(:threadreply).permit(:content)
  end
end