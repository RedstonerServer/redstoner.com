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
      [t.sticky ? 0 : 1, -(t.replies.order(:id).last.try(:created_at) || t.created_at).to_i]
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
      forum_badges = Badgeassociation.where(forum: @forum)
      ["read-", "write-"].each_with_index do |p,i|
        current_badges = forum_badges.where(permission: i+1).pluck(:badge_id)
        params.select{|k,v| k.start_with? p}.each do |k,v|
          name = k.gsub(p, "")
          if current_badges.include? (bid = Badge.find_by(name: name).id)
            current_badges.delete bid
          else
            Badgeassociation.create!(badge: Badge.find_by(name: name), forum: @forum, permission: i+1)
          end
        end
        current_badges.each {|b| Badgeassociation.find_by(badge_id: b, forum: @forum, permission: i+1).delete}
      end
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
      ["read-", "write-"].each_with_index do |p,i|
        params.select{|k,v| k.start_with? p}.each do |k,v|
          Badgeassociation.create!(badge: Badge.find_by(name: k.gsub(p, "")), forum: @forum, permission: i+1)
        end
      end
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
    a = [:name, :position, :role_read_id, :role_write_id, :necro_length] + add
    params.require(:forum).permit(a)
  end
end
