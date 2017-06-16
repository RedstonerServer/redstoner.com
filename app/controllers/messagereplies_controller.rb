class MessagerepliesController < ApplicationController

  def edit
    @reply = Messagereply.find(params[:id])
    if mod? || @reply.author.is?(current_user)
    else
      flash[:alert] = "You are not allowed to edit this reply"
      redirect_to @reply.message
    end
  end

  def create
    message = Message.find(params[:message_id])
    if [message.user_sender, message.user_target].include? current_user
      @reply = Messagereply.new(reply_params)
      @reply.user_author = current_user
      @reply.message = message
      if @reply.save
        if false
          @reply.send_new_message_reply_mail
        end
        Message.find(params[:message_id]).update_attributes(user_hidden: nil, user_unread_id: current_user.id)
        position = message.replies.count - 1
        page     = position / Kaminari.config.default_per_page + 1
        redirect_to message_path(@reply.message, page: page) + "#reply-#{@reply.id}", notice: 'Reply created!'
      else
        flash[:alert] = "Could not create reply."
        redirect_to Message.find(params[:message_id])
      end
    else
      flash[:alert] = "You are not allowed to create replies."
      redirect_to Message.find(params[:message_id])
    end
  end

  def update
    @reply = Messagereply.find(params[:id])
    if mod? || @reply.author.is?(current_user)
      old_content = @reply.text_was
      if @reply.update_attributes(reply_params)
        if false
          @reply.send_new_reply_mail(old_content)
        end
        flash[:notice] = "Reply updated!"
        position = @reply.message.replies.index(@reply)
        page     = position / Kaminari.config.default_per_page + 1
        redirect_to message_path(@reply.message, page: page) + "#reply-#{@reply.id}"
      else
        flash[:alert] = "There was a problem while updating your reply"
        render action: "edit"
      end
    else
      flash[:alert] = "You are not allowed to edit this reply"
      redirect_to @reply.message
    end
  end

  def destroy
    @reply = Messagereply.find(params[:id])
    if mod? || @reply.author.is?(current_user)
      if @reply.destroy
        flash[:notice] = "Reply deleted!"
      else
        flash[:alert] = "There was a problem while deleting this reply"
      end
    else
      flash[:alert] = "You are not allowed to delete this reply"
    end
    redirect_to @reply.message
  end

  private

  def reply_params
    params.require(:messagereply).permit(:text)
  end
end
