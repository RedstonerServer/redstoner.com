class BlogpostsController < ApplicationController
  # GET /blogposts
  # GET /blogposts.json
  def index
    @posts = Blogpost.all.reverse
  end

  # GET /blogposts/1
  # GET /blogposts/1.json
  def show
    @post = Blogpost.find(params[:id])
    @comment = Comment.new(:blogpost_id => @post.id)
  end

  # GET /blogposts/new
  # GET /blogposts/new.json
  def new
    @post = Blogpost.new
  end

  # GET /blogposts/1/edit
  def edit
    @post = Blogpost.find(params[:id])
  end

  # POST /blogposts
  # POST /blogposts.json
  def create
    @post = Blogpost.new(params[:blogpost])
    @post.user_id = current_user.id unless current_user.nil?
    if @post.save
      redirect_to @post, notice: 'Post has been created.'
    else
      render action: "new"
    end
  end

  # PUT /blogposts/1
  # PUT /blogposts/1.json
  def update
    @post = Blogpost.find(params[:id])

    if @post.update_attributes(params[:blogpost])
      redirect_to @post, notice: 'Post has been updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /blogposts/1
  # DELETE /blogposts/1.json
  def destroy
    @post = Blogpost.find(params[:id])
    @post.destroy

    redirect_to blogposts_url
    end
end
