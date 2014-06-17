class AddMailSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :mail_own_thread_reply, :boolean, default: true
    add_column :users, :mail_other_thread_reply, :boolean, default: true
    add_column :users, :mail_own_blogpost_comment, :boolean, default: true
    add_column :users, :mail_other_blogpost_comment, :boolean, default: true
    add_column :users, :mail_mention, :boolean, default: true
  end
end
