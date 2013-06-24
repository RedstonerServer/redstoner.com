class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.json
  def new
    if current_user
      flash[:alert] = "You are already registered!"
      redirect_to user_path(current_user.id)
    else
      @user = User.new
    end
  end

  # GET /users/1/edit
  def edit
    if current_user && (current_user.id = params[:id] || current_user.rank >= rank_to_int("mod"))
      @user = User.find(params[:id])
    else
      flash[:alert] = "You are not allowed to edit this user"
      redirect_to user_path(params[:id])
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.last_ip = request.remote_ip
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      flash[:alert] = "Something went wrong"
      render action: "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url
  end
end
