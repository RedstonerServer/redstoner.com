class CreateBlogposts < ActiveRecord::Migration
  def change
    create_table :blogposts do |t|
      t.string :title
      t.text :text
      t.integer :user_id

      t.timestamps
    end
  end
end
