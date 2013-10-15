class ForumsController < ApplicationController
   def index
    redirect_to :forumgroups
  end

  def show
    @forum = Forum.find(params[:id])
    @threads = @forum.forumthreads
  end

  def new
    if admin?
      @group = Forumgroup.find(params[:forumgroup_id])
      @forum = Forum.new(forumgroup: @group)
    else
      flash[:alert] = "You are not allowed to create a forum."
      redirect_to forumgroups_path
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