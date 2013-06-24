class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      user.last_ip = request.remote_ip
      user.last_login = Time.now
      user.save
      if user.banned
        flash[:alert] = "You are banned!"
        redirect_to login_path
      else
        session[:user_id] = user.id
        redirect_to root_path, :notice => "Logged in!"
      end
    else
      flash[:alert] = "You're doing it wrong!"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, :notice => "Logged out!"
  end
end