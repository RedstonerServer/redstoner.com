class ForumgroupsController < ApplicationController

  def index
    redirect_to forums_path
  end

  def show
    redirect_to forums_path + "#forums-#{params[:id]}"
  end

  def edit
  end

  def update

  end

  def new
    if admin?
      @group = Forumgroup.new
    else
      flash[:alert] = "You are not allowed to create forums."
      redirect_to forums_path
    end
  end

  def create
    if admin?
      @group = Forumgroup.new(params[:forumgroup])
      if @group.save
        flash[:notice] = "Forums created."
        redirect_to @group
      else
        flash[:alert] = "Something went wrong"
        render :new
      end
    else
      flash[:alert] = "You are not allowed to create forums."
      redirect_to forums_path
    end
  end



end