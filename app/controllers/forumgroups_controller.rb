class ForumgroupsController < ApplicationController

  def index
    @groups = Forumgroup.all
    if current_user
      @groups.select! do |g|
        g.role_read == nil || g.role_read <= current_user.role
      end
    else
      @groups.select!{|g| g.role_read == nil}
    end
    @groups.sort_by{|g| g[:position]}
  end

  def show
    redirect_to forumgroups_path + "#forums-#{params[:id]}"
  end

  def new
    if admin?
      @group = Forumgroup.new
    else
      flash[:alert] = "You are not allowed to create forums."
      redirect_to forumgroups_path
    end
  end

  def create
    if admin?
      @group = Forumgroup.new(params[:forumgroup])
      if @group.save
        flash[:notice] = "Forums created."
        redirect_to @group
      else
        flash[:alert] = "Something went wrong"
        render :new
      end
    else
      flash[:alert] = "You are not allowed to create forums."
      redirect_to forumgroups_path
    end
  end



end