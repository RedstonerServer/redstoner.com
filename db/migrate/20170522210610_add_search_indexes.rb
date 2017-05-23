class AddSearchIndexes < ActiveRecord::Migration
   def change
     add_index :forumthreads, [:title, :content], type: :fulltext
     add_index :threadreplies, :content, type: :fulltext
   end
 end
