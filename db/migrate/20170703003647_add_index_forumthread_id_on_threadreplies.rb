class AddIndexForumthreadIdOnThreadreplies < ActiveRecord::Migration
  def change
    add_index :threadreplies, :forumthread_id
  end
end
