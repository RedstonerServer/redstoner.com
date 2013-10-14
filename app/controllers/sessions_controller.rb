class SessionsController < ApplicationController
  require 'resolv'

  def new
    if current_user
      redirect_to current_user
      flash[:alert] = "You are already logged in!"
    end
  end

  def create
    unless current_user
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        hostname = ""
        begin
          hostname = Resolv.getname(request.remote_ip)
        rescue
          hostname = ""
        end
        user.last_ip = "#{request.remote_ip} | #{hostname}"
        user.last_login = Time.now
        user.save
        if user.disabled?
          flash[:alert] = "Your account has been disabled!"
          redirect_to login_path
        elsif user.banned?
          flash[:alert] = "You are banned!"
          redirect_to user
        else
          session[:user_id] = user.id
          flash[:alert] = "Remember to validate your email! Your account might be deleted" if user.unconfirmed?
          redirect_to root_path, :notice => "Logged in!"
        end
      else
        flash[:alert] = "You're doing it wrong!"
        render action: 'new'
      end
    else
      redirect_to current_user
      flash[:alert] = "You are already logged in!"
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, :notice => "Logged out!"
  end
end