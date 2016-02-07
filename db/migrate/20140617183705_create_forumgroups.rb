class CreateForumgroups < ActiveRecord::Migration
  def change
    create_table :forumgroups do |t|
      t.string     :name
      t.integer    :position

      t.references :role_read
      t.references :role_write
    end
  end
end