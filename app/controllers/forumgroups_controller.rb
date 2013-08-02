class ForumgroupsController < ApplicationController

  def index
    @groups = Forumgroup.all.sort{|s| s[:position]}
  end
end