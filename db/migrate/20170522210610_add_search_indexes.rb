class AddSearchIndexes < ActiveRecord::Migration
  def change
    add_index :forumthreads, [:title, :content], type: :fulltext
    add_index :forumthreads, :title, type: :fulltext
    add_index :forumthreads, :content, type: :fulltext    
    add_index :threadreplies, :content, type: :fulltext
  end
end
