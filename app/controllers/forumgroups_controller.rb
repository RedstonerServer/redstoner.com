class ForumgroupsController < ApplicationController
  def index
    @groups = Forumgroup.all.sort_by{|s| s[:position]}
  end

  def show
    redirect_to forumgroups_path + "#forum-#{params[:id]}"
  end
end