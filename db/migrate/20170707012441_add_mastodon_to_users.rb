class AddMastodonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mastodon, :string
  end
end
