class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.integer :position
      t.integer :read_permission
      t.integer :write_permission

      t.references :forumgroup
    end
  end
end
