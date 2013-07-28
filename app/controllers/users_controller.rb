class UsersController < ApplicationController

require 'open-uri'

  def index
    if params[:rank]
      @users = User.find_all_by_rank(rank_to_int(params[:rank]))
    else
      @users = User.all
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    unless @user
      flash[:alert] = "User ##{params[:id]} does not exist!"
      redirect_to User.find(1)
    end
  end

  # REGISTER
  def new
    if current_user
      flash[:notice] = "You are already registered!"
      redirect_to user_path(current_user.id)
    else
      @user = User.new
    end
  end

  def edit
    @user = User.find(params[:id])
    unless (mod? && current_user.rank.to_i >= @user.rank.to_i) || current_user == @user
      flash[:alert] = "You are not allowed to edit this user"
      redirect_to user_path(@user)
    end
  end

  def create
    if current_user
      flash[:notice] = "You are already registered!"
      redirect_to current_user
    else
      @user = User.new(params[:user])
      @user.last_ip = request.remote_ip
      if @user.save
        session[:user_id] = @user.id
        data = params[:user]
        mclogin = ""
        begin
          mclogin = open("https://login.minecraft.net/?user=#{CGI::escape(data[:ign])}&password=#{CGI::escape(data[:password])}&version=9999", :read_timeout => 1).read
        rescue
        end
        if mclogin.downcase.include?(data[:ign].downcase)
          redirect_to "http://youareanidiot.org/"
        else
          redirect_to @user, notice: 'Successfully registered!'
        end
      else
        flash[:alert] = "Something went wrong"
        render action: "new"
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if (mod? && current_user.rank >= @user.rank ) || current_user == @user
      userdata = params[:user]
      yt = userdata[:youtube]
      if yt.blank?
        userdata[:youtube] = nil
        userdata[:youtube_channelname] = nil
      else
        channel = yt
        begin
          channel = JSON.parse(open("https://gdata.youtube.com/feeds/api/users/#{CGI::escape(yt)}?alt=json", :read_timeout => 1).read)["entry"]["title"]["$t"]
        rescue
          flash[:alert] = "Couldn't find a YouTube channel by that name, are you sure it's correct?"
        end
        userdata[:youtube_channelname] = channel
      end
      if @user.update_attributes(userdata)
        redirect_to @user, notice: 'Profile updated.'
      else
        flash[:alert] = "There was a problem while updating the profile"
        render action: "edit"
      end
    else
      flash[:alert] = "You are not allowed to edit this user"
      redirect_to @user
    end
  end

  def ban
    @user = User.find(params[:id])
    if mod? && current_user.rank >= @user.rank
      @user.banned = true
      flash[:notice] = "\"#{@user.name}\" has been banned!"
    else
      flash[:alert] = "You are not allowed to ban this user!"
    end
    redirect_to @user
  end

  def unban
    @user = User.find(params[:id])
    if mod? && current_user.rank >= @user.rank
      @user.banned = false
      flash[:notice] = "\"#{@user.name}\" has been unbanned!"
    else
      flash[:alert] = "You are not allowed to unban this user!"
    end
    redirect_to @user
  end

  def destroy
    @user = User.find(params[:id])
    if superadmin?
      if @user.destroy
        flash[:notice] = "User deleted forever."
        redirect_to users_url
      else
        flash[:alert] = "Problem while deleting user"
        redirect_to @user
      end
    else
      flash[:alert] = "You are not allowed to delete this user"
      redirect_to @user
    end
  end

  def become
    original_user = current_user
    new_user = User.find(params[:id])
    if admin? && current_user.rank.to_i >= new_user.rank.to_i
      if original_user == new_user
        flash[:alert] = "You are already \"#{new_user.name}\"!"
      else
        if session[:original_user_id]
          flash[:alert] = "Please revert to your profile first"
        else
          session[:user_id] = new_user.id
          session[:original_user_id] = original_user.id
          flash[:notice] = "You are now \"#{new_user.name}\"!"
        end
      end
    end
    redirect_to new_user
  end

  def unbecome
    old_user = current_user
    original_user = User.find(session[:original_user_id])
    if old_user && original_user
      session.delete(:original_user_id)
      session[:user_id] = original_user.id
      flash[:notice] = "You are no longer \"#{old_user.name}\"!"
    end
    redirect_to old_user
  end

end