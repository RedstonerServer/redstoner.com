class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text       :content

      t.references :user_author
      t.references :user_editor
      t.references :blogpost

      t.timestamps null: true
    end
  end
end
