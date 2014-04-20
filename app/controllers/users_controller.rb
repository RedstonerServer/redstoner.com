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
      @users = User.all.to_a
      @users.shift #Remove first user
    end
    @users = @users.to_a.sort_by{|u| u.role}.reverse!
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
      @user = User.new
    end
  end

  def confirm
    if current_user
      @user = User.find(params[:id])
      code = params[:code]
      if @user && @user.is?(current_user) && code && @user.email_token == code
        if !confirmed?
          @user.confirmed = true
          if @user.save
            flash[:notice] = "Registration mail confirmed."
            redirect_to edit_user_path(@user)
            return
          else
            flash[:alert] = "Something went wrong, please contact us ingame."
            redirect_to @user
            return
          end
        elsif @user.role < Role.get(:normal)
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
      flash[:alert] = "Please login first"
      cookies[:return_path] = request.fullpath
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
      @user = User.new(user_params)
      user_profile = @user.get_profile
      if user_profile
        @user.uuid = user_profile["id"]
        @user.ign  = user_profile["name"] # correct case
        # TODO: uncomment when MC part works
        if true # validate_token(@user.uuid, @user.email, params[:registration_token])
          @user.last_ip = request.remote_ip # showing in mail
          if @user.save
            session[:user_id] = @user.id
            if @user.uses_mc_password?(params[:user][:password])
              is_idiot = true
              flash[:alert] = "Really? That's your Minecraft password!"
            else
              is_idiot = false
            end
            begin
              RedstonerMailer.register_mail(@user, is_idiot).deliver
              RedstonerMailer.register_info_mail(@user, is_idiot).deliver
            rescue => e
              puts "---"
              puts "WARNING: registration mail failed for user #{@user.name}, #{@user.email}"
              puts e.message
              puts "---"
              flash[:alert] = "Registration mail failed. Please contact us in-game."
            end
            flash[:notice] = "Successfully signed up! Check your email!"
            redirect_to edit_user_path(@user)
          else
            flash[:alert] = "Something went wrong"
            render action: "new"
          end
          @user.email_token = SecureRandom.hex(16)
        else
          flash[:alert] = "Token invalid for this username"
          render action: "new"
        end
      else
        flash[:alert] = "Error. Your username is not correct or Mojang's servers are down."
        render action: "new"
        return
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if (mod? && current_user.role >= @user.role ) || (@user.is?(current_user) && confirmed?)
      userdata = user_params([:name, :role_id, :skype, :skype_public, :youtube, :twitter, :about])
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
        flash[:alert] = "Couldn't find a YouTube channel with that name, are you sure it's correct?"  unless youtube[:is_correct?]
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
      @user.role = Role.get :normal
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



  private

  def validate_token(uuid, email, token)
    user_token = RegisterToken.where(uuid: uuid, email: email).first
    user_token && user_token.token == token
  end

  def user_params(add = [])
    a = [:ign, :email, :password, :password_confirmation] + add
    params.require(:user).permit(a)
  end
end