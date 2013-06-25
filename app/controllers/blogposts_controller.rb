class BlogpostsController < ApplicationController

  def index
    @posts = Blogpost.all.reverse
  end

  def show
    @post = Blogpost.find(params[:id])
    @comment = Comment.new(:blogpost => @post)
  end

  def new
    if current_user && current_user.rank >= rank_to_int("mod")
      @post = Blogpost.new
    else
      flash[:alert] = "You are not allowed to create a new post!"
      redirect_to blogposts_path
    end
  end

  def edit
      @post = Blogpost.find(params[:id])
      if current_user && ((current_user.rank >= rank_to_int("mod") && current_user.rank.to_i >= @post.user.rank.to_i) || (current_user == @edit.user))
    else
      flash[:alert] = "You are not allowed to update this post!"
    end
  end

  def create
    if current_user && current_user.rank >= rank_to_int("mod")
      @post = Blogpost.new(params[:blogpost])
      @post.user = current_user
      if @post.save
        redirect_to @post, notice: 'Post has been created.'
      else
        render action: "new"
      end
    else
      flash[:alert] = "You are not allowed to create new posts"
      redirect_to blog_path
    end
  end

  def update
    @post = Blogpost.find(params[:id])
    if current_user && ((current_user.rank >= rank_to_int("mod") && current_user.rank.to_i >= @post.user.rank.to_i) || (current_user == @post.user))
      if @post.update_attributes(params[:blogpost])
        redirect_to @post, notice: 'Post has been updated.'
      else
        flash[:alert] = "There was a problem while updating the post"
        render action: "edit"
      end
    end
  end

  def destroy
    @post = Blogpost.find(params[:id])
    if current_user && ((current_user.rank >= rank_to_int("mod") && current_user.rank.to_i >= @post.user.rank.to_i) || (current_user == @post.user))
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
