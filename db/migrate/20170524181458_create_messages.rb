class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :message
      t.references :user_sender
      t.references :user_target
      t.references :user_editor
      t.references :user_hidden
      t.boolean :read, default: false

      t.timestamps null: true
    end
  end
end
