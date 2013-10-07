class CreateForumgroups < ActiveRecord::Migration
  def change
    create_table :forumgroups do |t|
      t.string :name
      t.integer :position
      t.integer :read_permission
      t.integer :write_permission
    end
  end
end