class ForumgroupsController < ApplicationController

  def index
    @groups = Forumgroup.all.sort_by{|s| s[:position]}
  end
end