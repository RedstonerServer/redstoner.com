class ForumsController < ApplicationController
  before_filter :check_permission, only: [:show, :edit, :update, :destroy]

  def index
     @groups = Forumgroup.select {|g| g.can_view?(current_user) }
     @groups.sort_by!{ |g| g.position || 0 }
  end

  def show
    @threads = @forum.forumthreads.select {|f| f.can_read?(current_user) }.to_a
    @threads.sort_by! do |t|
      # sticky goes first, then sort by last activity (new replies)
      [t.sticky ? 0 : 1, -(t.replies.last.try(:created_at) || t.created_at).to_i]
    end
    @threads = Kaminari.paginate_array(@threads).page(params[:page])
  end

  def edit
    unless admin?
      flash[:alert] = "You are not allowed to change a forum"
      redirect_to forums_path
    end
  end

  def new
    if admin?
      @forum = Forum.new(forumgroup: @group)
      @forum.forumgroup = Forumgroup.find(params[:forumgroup])
    else
      flash[:alert] = "You are not allowed to create a forum."
      redirect_to forums_path
    end
  end

  def update
    if admin?
      if @forum.update_attributes(forum_params)
        flash[:notice] = "Forum updated"
        redirect_to @forum
      else
        flash[:alert] = "Something went wrong"
      end
    else
      flash[:alert] = "You are not allowed to change a forum"
      redirect_to @forum
    end
  end

  def create
    if admin?
      @forum = Forum.new(forum_params([:forumgroup_id]))
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

  def destroy
    if admin?
      if @forum.destroy
        flash[:notice] = "Forum deleted."
      else
        flash[:alert] = "Something went wrong"
        redirect_to @forum
        return
      end
    else
      flash[:alert] = "You are not allowed to delete a forum."
    end
    redirect_to forums_path
  end


  private

  def check_permission
    @forum = Forum.find(params[:id])
    unless @forum.can_view?(current_user)
      flash[:alert] = "You are not allowed to view this forum"
      redirect_to forums_path
    end
  end

  def forum_params(add = [])
    a = [:name, :position, :role_read_id, :role_write_id] + add
    params.require(:forum).permit(a)
  end
end