class CreateForumthreads < ActiveRecord::Migration
  def change
    create_table :forumthreads do |t|
      t.string :title
      t.text :content
      t.boolean :sticky, :default => false
      t.boolean :locked, :default => false

      t.references :user_author
      t.references :user_editor

      t.references :forum

      t.timestamps null: true
    end
  end
end
