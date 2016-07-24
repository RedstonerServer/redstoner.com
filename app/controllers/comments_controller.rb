class CommentsController < ApplicationController

  include MailerHelper

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
      @comment = Comment.new(comment_params)
      @comment.user_author = current_user
      @comment.blogpost = Blogpost.find(params[:blogpost_id])
      if @comment.save
        @comment.send_new_comment_mail
        position = @comment.blogpost.comments.count - 1
        page     = position / Kaminari.config.default_per_page + 1
        redirect_to blogpost_path(@comment.blogpost, page: page) + "#comment-#{@comment.id}", notice: 'Comment created!'
      else
        flash[:alert] = "Could not create comment."
        redirect_to Blogpost.find(params[:blogpost_id])
      end
    else
      flash[:alert] = "Please confirm your email address first!"
      redirect_to Blogpost.find(params[:blogpost_id])
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if mod? || @comment.author.is?(current_user)
      @comment.user_editor = current_user
      @comment.attributes = comment_params
      old_content = @comment.content_was
      if @comment.save
        @comment.send_new_comment_mail(old_content)
        flash[:notice] = "Comment updated!"
        position = @comment.blogpost.comments.index(@comment)
        page     = position / Kaminari.config.default_per_page + 1
        redirect_to blogpost_path(@comment.blogpost, page: page) + "#comment-#{@comment.id}"
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

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end