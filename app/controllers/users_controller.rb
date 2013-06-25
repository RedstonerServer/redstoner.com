class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
    unless current_user && ((current_user.rank >= rank_to_int("mod") && current_user.rank.to_i >= @user.rank.to_i) || (current_user == @user) && @user.id != 1 )
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
        redirect_to @user, notice: 'Successfully registered!'
      else
        flash[:alert] = "Something went wrong"
        render action: "new"
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if (current_user && @user.id != 1) && ( (current_user.rank >= rank_to_int("mod") && current_user.rank.to_i >= @user.rank.to_i) || current_user == @user)
      if @user.update_attributes(params[:user])
        redirect_to @user, notice: 'User was successfully updated.'
      else
        flash[:alert] = "There was a problem while updating this user"
        render action: "edit"
      end
    else
      flash[:alert] = "You are not allowed to edit this user"
      redirect_to @user
    end
  end

  def destroy
    @user = User.find(params[:id])
    if (current_user && @user.id != 1) && (current_user.rank >= rank_to_int("superadmin") && current_user.rank.to_i >= @user.rank.to_i)
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
end
