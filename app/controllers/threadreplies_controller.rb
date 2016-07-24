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
        @reply.send_new_reply_mail
        position = thread.replies.count - 1
        page     = position / Kaminari.config.default_per_page + 1
        redirect_to forumthread_path(@reply.thread, page: page) + "#reply-#{@reply.id}", notice: 'Reply created!'
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
      old_content = @reply.content_was
      if @reply.update_attributes(reply_params)
        @reply.send_new_reply_mail(old_content)
        flash[:notice] = "Reply updated!"
        position = @reply.thread.replies.index(@reply)
        page     = position / Kaminari.config.default_per_page + 1
        redirect_to forumthread_path(@reply.thread, page: page) + "#reply-#{@reply.id}"
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