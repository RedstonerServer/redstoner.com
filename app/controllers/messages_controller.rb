class MessagesController < ApplicationController

  before_filter :check_permission, only: [:destroy]

  def index
    if !current_user
      flash[:alert] = "Please log in to see your private messages."
      redirect_to blogposts_path
    end
    @messages = Message.where(user_target: current_user).page(params[:page])
  end

  def destroy
    if @message.user_target.is?(current_user)
      if @message.destroy
        flash[:notice] = "Message deleted!"
      else
        flash[:alert] = "There was a problem while deleting this message"
      end
    else
      flash[:alert] = "You are not allowed to delete this message"
    end
    redirect_to messages_path
  end

  def create
    if !message_params[:user_target_id]
      flash[:alert] = "Please enter a valid IGN before sending."
      redirect_to new_message_path
      return
    end
    if message_params[:text] == ""
      flash[:alert] = "Please write a message before sending."
      redirect_to new_message_path
      return
    end
    @message = Message.new(message_params)
    if @message.save
      flash[:notice] = "Message sent!"
      redirect_to messages_path
      return
    else
      flash[:alert] = "Something went wrong while creating your message."
      render action: "new"
      return
    end
  end

  def new
    if !current_user
      flash[:alert] = "Please log in to send a private message."
      redirect_to blogposts_path
      return
    end
    @message = Message.new
  end

  def message_params(add = [])
    params[:message][:user_target_id] = User.find_by(ign: params[:message][:user_target].gsub(/[@ ]/,"")).try(:id)
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
