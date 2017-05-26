class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|

      t.text :message
      t.references :user_sender
      t.references :user_target
      t.datetime :created_at
    end
  end
end
