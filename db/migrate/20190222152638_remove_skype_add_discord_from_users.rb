class RemoveSkypeAddDiscordFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :skype
    add_column    :users, :discord, :string
  end
end
