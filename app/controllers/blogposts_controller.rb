class BlogpostsController < ApplicationController

  def index
    @posts = Blogpost.all.reverse
  end

  def show
    @post = Blogpost.find(params[:id])
    @comment = Comment.new(:blogpost => @post)
  end

  def new
    if mod?
      @post = Blogpost.new
    else
      flash[:alert] = "You are not allowed to create a new post!"
      redirect_to blogposts_path
    end
  end

  def edit
      @post = Blogpost.find(params[:id])
      if mod?
    else
      flash[:alert] = "You are not allowed to edit this post!"
      redirect_to @post
    end
  end

  def create
    if mod?
      @post = Blogpost.new(params[:blogpost])
      @post.user_author = current_user
      if @post.save
        redirect_to @post, notice: 'Post has been created.'
      else
        flash[:alert] = @post.errors.first
        render action: "new"
      end
    else
      flash[:alert] = "You are not allowed to create new posts"
      redirect_to blog_path
    end
  end

  def update
    @post = Blogpost.find(params[:id])
    if mod?
      if @post.update_attributes(params[:blogpost])
        redirect_to @post, notice: 'Post has been updated.'
      else
        flash[:alert] = "There was a problem while updating the post"
        raise @post.errors
        render action: "edit"
      end
    end
  end

  def destroy
    @post = Blogpost.find(params[:id])
    if mod?
      if @post.destroy
        flash[:notice] = "Post deleted!"
      else
        flash[:alert] = "There was a problem while deleting this Post"
      end
    else
      flash[:alert] = "You are not allowed to delete this Post"
    end
    redirect_to blogposts_path
  end
end
