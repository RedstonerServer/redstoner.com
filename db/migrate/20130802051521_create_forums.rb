class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string "name"
      t.integer "position"
      t.references :forumgroup

      t.timestamps
    end
  end
end
