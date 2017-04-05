class UsersController < ApplicationController

  require 'open-uri'
  include MailerHelper
  include ERB::Util

  before_filter :set_user, except: [:index, :new, :create, :lost_password, :reset_password, :suggestions]

  def index
    if params[:role]
      if params[:role].downcase == "staff"
        @users = User.joins(:role).where("roles.value >= ?", Role.get(:mod).to_i)
      else
        if role = Role.get(params[:role])
          @users = User.joins(:role).where(role: role)
        else
          flash[:alert] = "role '#{params[:role]}' does not exist!"
          redirect_to users_path
          return
        end
      end
    elsif params[:badge]
      if badge = Badge.get(params[:badge])
        @users = User.joins(:badge).where(badge: badge)
      else
        flash[:alert] = "badge '#{params[:badge]}' does not exist!"
        redirect_to users_path
        return
      end
    else
      @users = User.joins(:role).where.not(id: User.first.id) #Remove first user
    end
    @users = @users.order("roles.value desc", "confirmed desc", :name) unless params[:badge]
    @count = @users.size
    @users = @users.page(params[:page]).per(100)
  end

  def show
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
      code = params[:code]
      if @user && @user.is?(current_user) && code && @user.email_token == code
        if !confirmed?
          @user.confirmed = true
          if @user.save
            flash[:notice] = "Your email has been confirmed."
            redirect_to @user
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
      elsif !@user.is?(current_user)
        flash[:alert] = "Wrong user, please log in as '#{@user.name}' first!"
        redirect_to root_path
      else
        flash[:alert] = "Something is wrong with your confirmation code"
        redirect_to root_path
      end
    else
      flash[:alert] = "Please login first"
      cookies[:return_path] = request.env['PATH_INFO']
      redirect_to login_path
    end
  end

  def edit
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

        if validate_token(@user.uuid, @user.email, params[:registration_token])
          destroy_token(params[:email])
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
              # these shouldn't be send in the background
              RedstonerMailer.register_mail(@user, is_idiot).deliver_now
              RedstonerMailer.register_info_mail(@user, is_idiot).deliver_now
            rescue => e
              Rails.logger.error "---"
              Rails.logger.error "WARNING: registration mail failed for user #{@user.try(:name)}, #{@user.try(:email)}"
              Rails.logger.error e.message
              Rails.logger.error "---"
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
          destroy_token(params[:email])
          flash[:alert] = "Token invalid for this username/email. Please generate a new token!"
          render action: "new"
        end
      else
        destroy_token(params[:email])
        flash[:alert] = "Username is not correct or Mojang's servers are down. Please generate a new token!"
        render action: "new"
        return
      end
    end
  end

  def resend_mail
    if (@user.is?(current_user) || mod?) && !@user.confirmed?
      RedstonerMailer.register_mail(@user, false).deliver_now
      flash[:notice] = "Check your inbox for the confirmation mail."
    else
      flash[:alert] = "You're not allowed to resend this user's confirmation email"
    end
    redirect_to user_path(@user)
  end

  def update
    if (mod? && current_user.role >= @user.role ) || (@user.is?(current_user) && confirmed?)
      if mod?
        userdata = user_params([:name, :skype, :skype_public, :youtube, :twitter, :about, :role, :badge, :confirmed])
      else
        userdata = user_params([:name, :skype, :skype_public, :youtube, :twitter, :about])
      end
      if userdata[:role]
        role = Role.get(userdata[:role])
        if role && role <= current_user.role
          userdata[:role] = role
        else
          # don't change role
          userdata.delete(:role)
        end
      end
      if userdata[:badge]
        userdata[:badge] = Badge.get(userdata[:badge])
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
    if mod? && current_user.role >= @user.role
      @user.role = Role.get :banned
      flash[:notice] = "'#{@user.name}' has been banned!"
    else
      flash[:alert] = "You are not allowed to ban this user!"
    end
    redirect_to @user
  end

  def unban
    if mod? && current_user.role >= @user.role
      @user.role = Role.get :normal
      flash[:notice] = "\"#{@user.name}\" has been unbanned!"
    else
      flash[:alert] = "You are not allowed to unban this user!"
    end
    redirect_to @user
  end

  def destroy
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

  def edit_notifications
    unless @user.is?(current_user) || admin? && current_user.role > @user.role || superadmin?
      flash[:alert] = "You are not allowed to edit this user's notification settings!"
      redirect_to @user
    end
  end

  def edit_login
    unless @user.is?(current_user) || admin? && current_user.role > @user.role || superadmin?
      flash[:alert] = "You are not allowed to edit this user's login details!"
      redirect_to @user
    end
  end

  def update_login
    if @user.is?(current_user) || admin? && current_user.role > @user.role || superadmin?
      authenticated = !@user.is?(current_user) || @user.authenticate(params[:current_password])
      if params[:user][:password].present?
        @user.password              = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
      end
      @user.email       = params[:user][:email] if params[:user][:email].present?
      mail_changed      = @user.email_changed?
      @user.email_token = SecureRandom.hex(16) if mail_changed
      @user.confirmed   = !mail_changed

      # checking here for password so we can send back changes to the view
      if authenticated
        if @user.save
          flash[:notice] = "Login details updated!"
          if mail_changed
            begin
              background_mailer([RedstonerMailer.email_change_confirm_mail(@user)])
              flash[:notice] += " Please check your inbox."
            rescue
              Rails.logger.error "---"
              Rails.logger.error "WARNING: email change confirmation mail (view) failed for user #{@user.try(:name)}, #{@user.try(:email)}"
              Rails.logger.error e.message
              Rails.logger.error "---"
              flash[:alert] = "We're having problems with your confirmation mail, please contact us!"
            end
          end
          redirect_to @user
        else
          flash[:alert] = "Error while updating your login details!"
          render action: "edit_login"
        end
      else
        flash[:alert] = "Wrong password!"
        render action: "edit_login"
      end

    else
      flash[:alert] = "You are not allowed to edit this user's login details!"
      redirect_to @user
    end
  end

  def lost_password
    if current_user
      flash[:notice] = "You're already logged in!"
      redirect_to current_user
    end
  end

  def reset_password
    if profile = User.new(ign: params[:ign]).get_profile
      uuid = profile && profile["id"]
      user = uuid && User.find_by(email: params[:email], uuid: uuid)
      if user && validate_token(user.uuid, user.email, params[:secret_token])
        destroy_token(params[:email])
        user.password              = params[:new_password]
        user.password_confirmation = params[:new_password]
        if user.save
          flash[:notice] = "Password has been reset"
          redirect_to login_path
          return
        else
          flash[:alert] = "Failed to update password. Please generate a new token!"
        end
      else
        destroy_token(params[:email])
        flash[:alert] = "Token or Email address invalid. Please generate a new token!"
      end
    else
      destroy_token(params[:email])
      flash[:alert] = "Username is not correct or Mojang's servers are down. Please generate a new token!"
    end
    render action: "lost_password"
  end

  def suggestions
    query = params[:name]
    # same regex as the one used for textcomplete
    if current_user && query.present? && query =~ /\A([^!"§$%&\/()=?.,;+*@\s]{1,16} ?){0,1}[^!"§$%&\/()=?.,;+*@\s]{1,16}\Z/
      query.gsub!(/[_%]/) {|c|"\\#{c}"} # escape LIKE wildcard characters
      @users = User.where("ign LIKE ? or name LIKE ?", "%#{query}%", "%#{query}%").order(:name, :ign).limit(7)
      @users = @users.to_a.map{|u| [html_escape(u.name), html_escape(u.ign)]}
      render json: @users
    else
      puts "'#{query}' does not match regex!"
      render json: []
    end
  end

  private

  def validate_token(uuid, email, token)
    user_token = RegisterToken.where(uuid: uuid, email: email).first
    user_token && user_token.token == token
  end

  # delete tokens that have been queried, regardless of matching token
  # prevents brute forcing
  def destroy_token(email)
    RegisterToken.where(email: email).destroy_all
  end

  def set_user
    id = params[:id]
    if id == "me"
      if current_user
        id = current_user.id
      else
        flash[:alert] = "Please log in"
        redirect_to login_path(return_path: request.env['PATH_INFO'])
        return
      end
    end
    @user = User.find(id)
  end

  def user_params(add = [])
    a = [:ign, :email, :password, :password_confirmation, :mail_own_thread_reply, :mail_other_thread_reply, :mail_own_blogpost_comment, :mail_other_blogpost_comment, :mail_mention] + add
    params.require(:user).permit(a)
  end
end
