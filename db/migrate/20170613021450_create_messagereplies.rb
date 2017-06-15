class CreateMessagereplies < ActiveRecord::Migration
  def change
    create_table :messagereplies do |t|
      t.text       :text

      t.references :user_author
      t.references :user_editor
      t.references :message

      t.timestamps null: true
    end
  end
end
