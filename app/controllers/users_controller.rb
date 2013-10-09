class UsersController < ApplicationController

require 'open-uri'

  def index
    if params[:role]
      if params[:role].downcase == "staff"
        @users = User.all.select {|u| u.role >= Role.get(:mod) }
      else
        @users = User.find_all_by_role_id(Role.get(params[:role]))
      end
    else
      @users = User.all
      @users.shift() #Remove first user
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    unless @user
      flash[:alert] = "User does not exist!"
      redirect_to users_path
    end
  end

  # SIGNUP
  def new
    if current_user
      flash[:notice] = "You are already signed up!"
      redirect_to current_user
    else
      @user = User.new(role: Role.get(:unconfirmed))
    end
  end

  def confirm
    if current_user
      @user = User.find(params[:id])
      code = params[:code]
      if @user && @user == current_user && code && @user.confirm_code == code
        if @user.role == Role.get(:unconfirmed)
          @user.role = Role.get :default
          @user.save
          flash[:notice] = "Registration confirmed."
        elsif @user.role < Role.get(:unconfirmed)
          flash[:alert] = "Your account has been banned or removed"
        else
          flash[:alert] = "Your account has already been confirmed!"
        end
        redirect_to @user
      else
        flash[:alert] = "Something is wrong with your confirmation code"
        redirect_to root_path
      end
    else
      flash[:alert] = "Please login"
      redirect_to login_path
    end
  end

  def edit
    @user = User.find(params[:id])
    unless (mod? && current_user.role >= @user.role) || current_user == @user
      flash[:alert] = "You are not allowed to edit this user"
      redirect_to user_path(@user)
    end
  end

  def create
    if current_user
      flash[:notice] = "You are already signed up!"
      redirect_to current_user
    else
      @user = User.new(params[:user] ? params[:user].slice(:name, :ign, :email, :password, :password_confirmation) : {} )
      @user.role = Role.get :unconfirmed
      @user.confirm_code = SecureRandom.hex(16)
      @user.last_ip = request.remote_ip
      @user.last_login = Time.now
      if @user.save
        session[:user_id] = @user.id
        if uses_mc_password?(@user.ign, params[:user][:password])
          minecraftpw = true
          flash[:alert] = "Really? That's your Minecraft password!"
        end
        # begin
          RedstonerMailer.register_mail(@user, minecraftpw).deliver
          RedstonerMailer.register_info_mail(@user, minecraftpw).deliver
        # rescue
         # puts "---"
         # puts "WARNING: registration mail failed for user #{@user.name}, #{@user.email}"
         # puts "---"
         # flash[:alert] = "Registration mail failed. Please contact us in-game."
       # end
        flash[:notice] = "Successfully signed up! Check your email!"
        redirect_to edit_user_path(@user)
      else
        flash[:alert] = "Something went wrong"
        render action: "new"
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if (mod? && current_user.role >= @user.role ) || (@user.is?(current_user) && confirmed?)
      userdata = params[:user] ? params[:user].slice(:name, :ign, :role_id, :skype, :skype_public, :youtube, :twitter, :about, :password, :password_confirmation) : {}
      if userdata[:role_id]
        role = Role.find(userdata[:role_id])
        if (mod? && role <= current_user.role)
          userdata[:role_id] = role.id
        else
          #reset role
          userdata[:role_id] = @user.role.id
        end
      end
      unless userdata[:ign] && (mod? && current_user.role >= @user.role)
        #reset ign
        userdata[:ign] = @user.ign
      end
      if @user.youtube != userdata[:youtube]
        youtube = get_youtube(userdata[:youtube])
        userdata[:youtube] = youtube[:channel]
        userdata[:youtube_channelname] = youtube[:channel_name]
        flash[:alert] = "Couldn't find a YouTube channel by that name, are you sure it's correct?"  unless youtube[:is_correct?]
      end
      if @user.update_attributes(userdata)
          flash[:notice] = 'Profile updated.'
      else
        flash[:alert] = "There was a problem while updating the profile"
        render action: "edit"
        return
      end
    else
      flash[:alert] = "You are not allowed to edit this user"
    end
      redirect_to @user
  end

  def ban
    @user = User.find(params[:id])
    if mod? && current_user.role >= @user.role
      @user.role = Role.get :banned
      flash[:notice] = "'#{@user.name}' has been banned!"
    else
      flash[:alert] = "You are not allowed to ban this user!"
    end
    redirect_to @user
  end

  def unban
    @user = User.find(params[:id])
    if mod? && current_user.role >= @user.role
      @user.role = Role.get :default
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
    if admin? && current_user.role >= new_user.role
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
    if old_user && original_user && original_user.admin?
      session.delete(:original_user_id)
      session[:user_id] = original_user.id
      flash[:notice] = "You are no longer '#{old_user.name}'!"
    end
    redirect_to old_user
  end

end