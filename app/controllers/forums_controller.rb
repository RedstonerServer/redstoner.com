class ForumsController < ApplicationController
  before_filter :check_permission, only: [:show]

  def index
     @groups = Forumgroup.all
     @groups.select!{|g| g.can_read?(current_user) }
     @groups.sort_by!{|g| g[:position]}
  end

  def show
    @threads = @forum.forumthreads.order("sticky desc, updated_at desc")
  end

  def new
    if admin?
      @group = Forumgroup.find(params[:forumgroup])
      @forum = Forum.new(forumgroup: @group)
    else
      flash[:alert] = "You are not allowed to create a forum."
      redirect_to forums_path
    end
  end

  def create
    if admin?
      @forum = Forum.new(params[:forum])
      @forum.forumgroup = Forumgroup.find(params[:forum][:forumgroup_id])
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


  private

  def check_permission
    @forum = Forum.find(params[:id])
    unless @forum.can_read?(current_user)
      flash[:alert] = "You are not allowed to view this forum"
      redirect_to forums_path
    end
  end


end