class SessionsController < ApplicationController

  def new
    if current_user
      flash[:alert] = "You are already logged in!"
      redirect_to current_user
    else
      cookies[:return_path] = params[:return_path] if params[:return_path]
    end
  end

  def create
    unless current_user
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        if user.disabled?
          flash[:alert] = "Your account has been disabled!"
        elsif user.banned?
          flash[:alert] = "You are banned!"
        else
          session[:user_id] = user.id
          flash[:alert] = "Remember to validate your email! Your account may be deleted soon!" if !user.confirmed?
          flash[:notice] = "Logged in!"
        end
      else
        flash[:alert] = "You're doing it wrong!"
        render action: 'new'
        return
      end
    else
      flash[:alert] = "You are already logged in!"
    end
    if cookies[:return_path]
      redirect_to cookies[:return_path]
      cookies.delete(:return_path)
    else
      redirect_to root_path
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, :notice => "Logged out!"
  end
end