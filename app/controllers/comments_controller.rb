class CommentsController < ApplicationController

  def edit
    @comment = Comment.find(params[:id])
    if mod? || @comment.author.is?(current_user)
    else
      flash[:alert] = "You are not allowed to edit this comment"
      redirect_to @comment.blogpost
    end
  end

  def create
    if confirmed?
      params[:comment].slice!("content") if params[:comment]
      @comment = Comment.new(params[:comment])
      @comment.user_author = current_user
      @comment.blogpost = Blogpost.find(params[:blogpost_id])
      if @comment.save
        redirect_to @comment.blogpost, notice: 'Comment created!'
      else
        flash[:alert] = "Could not create comment."
        redirect_to Blogpost.find(params[:blogpost_id])
      end
    else
      flash[:alert] = "You are not allowed to create comments."
      redirect_to Blogpost.find(params[:blogpost_id])
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if mod? || @comment.author.is?(current_user)
      params[:comment].slice!("content") if params[:comment]
      if @comment.update_attributes(params[:comment])
        flash[:notice] = "Comment updated!"
        redirect_to @comment.blogpost
      else
        flash[:alert] = "There was a problem while updating your comment"
        render action: "edit"
      end
    else
      flash[:alert] = "You are not allowed to edit this comment"
      redirect_to @comment.blogpost
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if mod? || @comment.author.is?(current_user)
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