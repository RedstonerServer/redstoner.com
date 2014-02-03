class ForumsController < ApplicationController
  def index
     @groups = Forumgroup.all
     if current_user
       @groups.select! do |g|
         g.role_read.nil? || g.role_read <= current_user.role
       end
     else
       @groups.select!{|g| g.role_read == nil}
     end
     @groups.sort_by{|g| g[:position]}
  end

  def show
    @forum = Forum.find(params[:id])
    if @forum.role_read.nil? || current_user && @forum.role_read <= current_user.role
      @threads = @forum.forumthreads.order("sticky desc, updated_at desc")
    else
      redirect_to forums_path
    end
  end

  def new
    if admin?
      @group = Forumgroup.find(params[:forumgroup_id])
      @forum = Forum.new(forumgroup: @group)
    else
      flash[:alert] = "You are not allowed to create a forum."
      redirect_to forums_path
    end
  end

  def create
    if admin?
      @forum = Forum.new(params[:forum])
      @forum.forumgroup = Forumgroup.find(params[:forumgroup_id])
      if @forum.save
        flash[:notice] = "Forum created."
        redirect_to @forum
      else
        flash[:alert] = "Something went wrong"
        render :new
      end
    else
      flash[:alert] = "You are not allowed to create a forum."
      redirect_to forums_path
    end
  end

end