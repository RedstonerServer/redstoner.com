class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.integer :position

      t.references :role_read
      t.references :role_write

      t.references :forumgroup
    end
  end
end
