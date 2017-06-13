class MessagesController < ApplicationController

  before_filter :check_permission, only: :destroy

  def index
    if current_user
      @messages = Message.where(user_target: current_user).page(params[:page])
    else
      flash[:alert] = "Please log in to see your private messages."
      redirect_to blogposts_path
    end
  end

  def new
    if current_user
      @message = Message.new
    else
      flash[:alert] = "Please log in to send a private message."
      redirect_to blogposts_path
    end
  end

  def create
    unless message_params[:user_target_id]
      flash[:alert] = "Please enter a valid IGN before sending."
      redirect_to new_message_path
      return
    end
    if message_params[:text].blank?
      flash[:alert] = "Please write a message before sending."
      redirect_to new_message_path
      return
    end
    @message = Message.new(message_params)
    @message.user_target = User.find(@message.user_target_id)
    if @message.save
      @message.send_new_message_mail
      flash[:notice] = "Message sent!"
      redirect_to messages_path
    else
      flash[:alert] = "Something went wrong while creating your message."
      render action: "new"
    end
  end

  def destroy
    if @message.user_target.is?(current_user)
      if @message.destroy
        flash[:notice] = "Message deleted!"
      else
        flash[:alert] = "There was a problem while deleting this message."
      end
    else
      flash[:alert] = "You are not allowed to delete this message."
    end
    redirect_to messages_path
  end

  def destroy_all
    Message.destroy_all(user_target_id: current_user.id)
    if Message.where(user_target_id: current_user.id).empty?
      flash[:notice] = "Your messages have been deleted!"
    else
      flash[:alert] = "There was a problem while deleting your messages."
    end
    redirect_to messages_path
  end

  def message_params(add = [])
    params[:message][:user_target_id] = User.find_by(ign: params[:message][:user_target].strip).try(:id)
    params[:message][:user_sender_id] = User.find_by(ign: params[:message][:user_sender]).id

    params.require(:message).permit([:text, :user_target_id, :user_sender_id])
  end

  private

  def check_permission
    @message = Message.find(params[:id])
    unless @message.user_target == current_user
      flash[:alert] = "You are not allowed to view this message"
      redirect_to home_statics_path
    end
  end
end
