class AddForumgroups < ActiveRecord::Migration
  def change
    create_table :forumgroups do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
  end
end