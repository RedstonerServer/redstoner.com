class AddYoutubeChannelname < ActiveRecord::Migration
  def up
    add_column :users, :youtube_channelname, :string
  end

  def down
  end
end
