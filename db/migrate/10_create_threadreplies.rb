class CreateThreadreplies < ActiveRecord::Migration
  def change
    create_table :threadreplies do |t|
      t.text       :content

      t.references :user_author
      t.references :user_editor
      t.references :forumthread

      t.timestamps null: true
    end
  end
end
