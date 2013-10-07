class ForumthreadsController < ApplicationController
  def index
    f = Forum.find(params[:id])
    redirect_to forum_path(f.forumgroup, f)
  end
end