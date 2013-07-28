class AddYoutubeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :youtube, :string
  end
end
