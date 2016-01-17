class CreateBlogposts < ActiveRecord::Migration
  def change
    create_table :blogposts do |t|
      t.string     :title
      t.text       :content

      t.references :user_author
      t.references :user_editor

      t.timestamps null: true
    end
  end
end