class ForumthreadsController < ApplicationController

  before_filter :check_permission, only: [:show, :edit, :update, :destroy]

  def index
    params[:forum] = nil if params[:forum] && !Forum.find_by(id: params[:forum])

    params.delete_if{|k,v| v.blank?}

    @threads = Forumthread.filter(current_user, params[:title].try(:slice, 0..255), params[:content].try(:slice, 0..255), params[:reply].try(:slice, 0..255), params[:label], User.find_by(ign: params[:author].to_s.strip) || params[:author], params[:query].try(:slice, 0..255), Forum.find_by(id: params[:forum]))
    .page(params[:page]).per(30)
  end
  def show
    if params[:reverse] == "true"
      @replies = @thread.replies.order(id: :desc).page(params[:page])
    else
      @replies = @thread.replies.order(:id).page(params[:page])
    end
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
