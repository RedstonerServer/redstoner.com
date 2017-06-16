class MessagesController < ApplicationController

  before_filter :set_current
  def set_current
    User.current = current_user
  end

  before_filter :check_permission, only: [:show, :edit, :update, :destroy]

  def index
    if current_user
      @messages = Message.where("(user_sender_id = ? OR user_target_id = ?) AND (user_hidden_id != ? OR user_hidden_id IS NULL)", current_user.id, current_user.id, current_user.id).page(params[:page])
    else
      flash[:alert] = "Please log in to see your private messages."
      redirect_to blogposts_path
    end
  end

  def show
    Message.find(@message.id).update_attributes(user_unread: nil) if @message.user_unread && @message.user_target.is?(current_user)
    @replies = @message.replies.page(params[:page])
  end

  def edit
    unless mod? || @message.author.is?(current_user)
      flash[:alert] = "You are not allowed to edit this message!"
      redirect_to @message
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
    if message_params[:subject].blank?
      flash[:alert] = "Please write a subject before sending."
      redirect_to new_message_path
      return
    elsif message_params[:text].blank?
      flash[:alert] = "Please write a message before sending."
      redirect_to new_message_path
      return
    end
    @message = Message.new(message_params)
    @message.user_target = User.find(@message.user_target_id)
    @message.user_unread = User.find(@message.user_unread_id) if @message.user_unread_id
    if @message.save
      @message.send_new_message_mail
      flash[:notice] = "Message sent!"
      redirect_to messages_path
    else
      flash[:alert] = "Something went wrong while creating your message."
      render action: "new"
    end
  end

  def update
    if mod? || @message.user_sender.is?(current_user)
      @message.user_editor_id = current_user.id
      @message.attributes = message_params
      if @message.save
        redirect_to @message, notice: 'Message has been updated.'
      else
        flash[:alert] = "There was a problem while updating the message."
        render action: "edit"
      end
    else
      flash[:alert] = "You are not allowed to edit this message!"
      redirect_to @message
    end
  end

  def destroy
    if [@message.user_target, @message.user_sender].include?(current_user)
      if @message.destroy
        flash[:notice] = "Message deleted!"
      else
        unless @message.user_hidden
          flash[:alert] = "There was a problem while deleting this message."
        else
          Message.find(@message.id).update_attributes(user_hidden: current_user)
        end
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
    params[:message][:user_hidden_id] = User.find_by(ign: params[:message][:user_hidden]).try(:id)
    params[:message][:user_unread_id] = User.find_by(ign: params[:message][:user_unread]).try(:id)
params.require(:message).permit([:subject, :text, :user_target_id, :user_sender_id, :user_hidden_id, :user_unread_id])
  end

  private

  def check_permission
    @message = Message.find(params[:id])
    unless [@message.user_target, @message.user_sender].include? current_user
      flash[:alert] = "You are not allowed to view this message"
      redirect_to home_statics_path
    end
  end
end
