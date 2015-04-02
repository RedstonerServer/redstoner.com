class BlogpostsController < ApplicationController

  before_filter :set_post, except: [:index, :new, :create]
  before_filter :auth, except: [:index, :show]

  def index
    @posts = Blogpost.order("created_at desc").page(params[:page]).per(10)
  end

  def show
    @comment = Comment.new(blogpost: @post)
    @comments = @post.comments.page(params[:page])
  end

  def new
    @post = Blogpost.new
  end

  def edit
  end

  def create
    @post = Blogpost.new(post_params)
    @post.user_author = current_user
    if @post.save
      @post.send_new_mention_mail
      redirect_to @post, notice: 'Post has been created.'
    else
      flash[:alert] = "Error creating blogpost"
      render action: "new"
    end
  end

  def update
    @post.user_editor = current_user
    @post.attributes = post_params([:user_editor])
    old_content = @post.content_was
    if @post.save
      @post.send_new_mention_mail(old_content)
      redirect_to @post, notice: 'Post has been updated.'
    else
      flash[:alert] = "There was a problem while updating the post"
      render action: "edit"
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Post deleted!"
    else
      flash[:alert] = "There was a problem while deleting this Post"
    end
    redirect_to blogposts_path
  end


  private

  def post_params(add = [])
    a = [:title, :content]
    a += add
    params.require(:blogpost).permit(a)
  end

  def set_post
    if params[:id]
      @post = Blogpost.find(params[:id])
    end
  end

  def auth
    unless mod?
      flash[:alert] = "You are not allowed to edit posts!"
      redirect_to @post ? @post : blogposts_path
    end
  end

end