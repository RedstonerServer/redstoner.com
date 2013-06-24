class CommentsController < ApplicationController

  def edit
    @comment = Comment.find(params[:id])
    if current_user && ((current_user.rank >= rank_to_int("mod") && current_user.rank.to_i >= @comment.user.rank.to_i) || (current_user == @comment.user))
      @comment = Comment.find(params[:id])
      session[:return_to] = blogpost_path(@comment.blogpost)
    else
      flash[:alert] = "You are not allowed to edit this comment"
      redirect_to @comment.blogpost
    end
  end

  def create
    if current_user
      @comment = Comment.new(params[:comment])
      @comment.user_id = current_user.id
      @comment.blogpost = Blogpost.find(params[:blogpost_id])
      if @comment.save
        redirect_to @comment.blogpost, notice: 'Comment created!'
      else
        flash[:alert] = "There was a problem while saving your comment"
        redirect_to blogpost_path(params[:blogpost_id])
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if current_user && ((current_user.rank >= rank_to_int("mod") && current_user.rank.to_i >= @comment.user.rank.to_i) || (current_user == @comment.user))
      if @comment.update_attributes(params[:comment])
        flash[:notice] = "Comment updated!"
        redirect_to @comment.blogpost
      else
        flash[:alert] = "There was a problem while updating your comment"
        redirect_to session[:return_to]
        session.delete(:redirect_to)
      end
    else
      flash[:alert] = "You are not allowed to edit this comment"
      redirect_to blogpost_path(params[:blogpost_id])
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if current_user && ((current_user.rank >= rank_to_int("mod") && current_user.rank.to_i >= @comment.user.rank.to_i) || (current_user == @comment.user))
      if @comment.destroy
        flash[:notice] = "Comment deleted!"
      else
        flash[:alert] = "There was a problem while deleting this comment"
      end
    else
      flash[:alert] = "You are not allowed to delete this comment"
    end
    redirect_to @comment.blogpost
  end
end