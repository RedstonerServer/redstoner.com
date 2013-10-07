class ForumsController < ApplicationController
   def index
    redirect_to :forumgroups
  end

  def show
    @forum = Forum.find(params[:id])
    @threads = @forum.forumthreads
  end

end