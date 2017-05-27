class ForumthreadsController < ApplicationController

  before_filter :check_permission, only: [:show, :edit, :update, :destroy]

  def index
    if params[:label] && !Label.where("lower(name) = ?", params[:label].downcase).try(:first) && params[:label].downcase != "no label"
      flash[:alert] = "'#{params[:label]}' is not a valid label."
      redirect_to forumthreads_path(params.except(:label, :controller, :action))
      return
    end
    @threads = Forumthread.filter(current_user, params[:title], params[:content], params[:reply], params[:label], User.where("lower(ign) = ?", params[:author].to_s.downcase).try(:first), params[:query], Forum.where(id: params[:id]).try(:first))
    .page(params[:page]).per(30)
  end
  def show
    @replies = @thread.replies.page(params[:page])
  end

  def edit
    unless mod? || @thread.author.is?(current_user)
      flash[:alert] = "You are not allowed to edit this thread!"
      redirect_to @thread
    end
  end

  def new
    @thread = Forumthread.new(forum: Forum.find(params[:forum]))
    unless @thread.forum.can_write?(current_user)
      flash[:alert] = "You are not allowed to write in this forum"
      redirect_to forums_path
    end
  end

  def create
    @thread = Forumthread.new(mod? ? thread_params([:sticky, :locked, :forum_id, :label_id]) : thread_params([:forum_id, :label_id]))
    if @thread.forum.can_write?(current_user)
      @thread.user_author = current_user
      if @thread.save
        @thread.send_new_mention_mail
        flash[:notice] = "Thread created!"
        redirect_to forumthread_path( @thread)
        return
      else
        flash[:alert] = "Something went wrong while creating your thread."
        render action: "new"
        return
      end
    else
      flash[:alert] = "You are not allowed to create a thread here!"
      redirect_to @thread.forum
    end
  end

  def update
    if mod? || @thread.author.is?(current_user)
      @thread.user_editor = current_user
      @thread.attributes = (mod? ? thread_params([:sticky, :locked, :forum_id, :label_id]) : thread_params)
      old_content = @thread.content_was
      if @thread.save
        @thread.send_new_mention_mail(old_content)
        redirect_to @thread, notice: 'Post has been updated.'
      else
        flash[:alert] = "There was a problem while updating the post"
        render action: "edit"
      end
    else
      flash[:alert] = "You are not allowed to edit this thread!"
      redirect_to @thread
    end
  end

  def destroy
    if mod? || @thread.author.is?(current_user)
      if @thread.destroy
        flash[:notice] = "Thread deleted!"
      else
        flash[:alert] = "There was a problem while deleting this thread"
      end
    else
      flash[:alert] = "You are not allowed to delete this thread"
    end
    redirect_to @thread.forum
  end

  def search
  end

  def search_redirect
    params.each do |key, value|
      params[key] = nil if params[key] == ""
    end
    params[:id] = nil if params[:id] == "Search All Threads"
    params[:label] = nil if params[:label] && params[:label].downcase == "label"
    params[:author] = params[:author].tr("@ ", "") if params[:author]
    params_list = Hash[params.except(:commit, :utf8, :authenticity_token)]
    redirect_to forumthreads_path(params_list)
  end

  private

  def check_permission
    @thread = Forumthread.find(params[:id])
    unless @thread.can_read?(current_user)
      flash[:alert] = "You are not allowed to view this thread"
      redirect_to forums_path
    end
  end

  def thread_params(add = [])
    a = [:title, :content]
    a << :label_id if @thread && !@thread.locked?
    a += add
    params.require(:forumthread).permit(a)
  end
end
