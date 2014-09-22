class ForumgroupsController < ApplicationController

  def index
    redirect_to forums_path
  end

  def show
    redirect_to forums_path + "#group-#{params[:id].to_i}"
  end

  def edit
    if admin?
      @group = Forumgroup.find(params[:id])
    else
      flash[:alert] = "You are not allowed to edit forum groups."
    end
  end

  def update
    if admin?
      @group = Forumgroup.find(params[:id])
      if @group.update_attributes(group_params)
        flash[:notice] = "Forum group updated"
        redirect_to @group
      else
        flash[:alert] = "Something went wrong"
        render :edit
      end
    else
      flash[:alert] = "You are not allowed to change forum groups"
    end
  end

  def new
    if admin?
      @group = Forumgroup.new
    else
      flash[:alert] = "You are not allowed to create forum groups."
      redirect_to forums_path
    end
  end

  def create
    if admin?
      @group = Forumgroup.new(group_params)
      if @group.save
        flash[:notice] = "Forum group created."
        redirect_to @group
      else
        flash[:alert] = "Something went wrong"
        render :new
      end
    else
      flash[:alert] = "You are not allowed to create forum groups."
      redirect_to forums_path
    end
  end

  def destroy
    if admin?
      @group = Forumgroup.find(params[:id])
      if @group.destroy
        flash[:notice] = "forum group deleted."
      else
        flash[:alert] = "Something went wrong"
      end
    else
      flash[:alert] = "You are not allowed to delete forum groups."
    end
    redirect_to forums_path
  end

  private

  def group_params(add = [])
    a = [:name, :position, :role_read_id, :role_write_id] + add
    params.require(:forumgroup).permit(a)
  end

end